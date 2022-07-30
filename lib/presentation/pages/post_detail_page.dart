import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/get_post_detail_content/get_post_detail_content_cubit.dart';
import '../bloc/get_post_detail_content/get_post_detail_content_state.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../bloc/refresh_product/refresh_product_cubit.dart';
import '../bloc/refresh_product/refresh_product_state.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/post_detail/post_content_to_show.dart';
import '../widgets/post_detail/post_detail_app_bar.dart';
import 'edit_post_page.dart';

class PostDetailPage extends StatefulWidget {
  static String routeName = "/postDetail";
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Product? product;
  User? currentUser;
  String? authToken;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initalizeNeededData();
    });
  }

  void initalizeNeededData() {
    setState(() {
      currentUser = getCurrentUser();
      authToken = getToken();
      product = ModalRoute.of(context)!.settings.arguments as Product;
    });
    context.read<HandleGoingToMessageCubit>().clear();
    context.read<RefreshProductCubit>().clear();
    context
        .read<GetPostDetailContentCubit>()
        .execute(product!.createdBy, authToken!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: renderAppBar(),
        body: BlocBuilder<GetPostDetailContentCubit, GetPostDetailContentState>(
          builder: (context, state) {
            if (state is Loading || product == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Error) {
              return buildErrorContent();
            } else if (state is NoNetwork) {
              return buildNoNetworkContent();
            } else if (state is Loaded) {
              return renderBody(state.favoriteProducts, state.postCreator);
            }
            return Container();
          },
        ),
      ),
    );
  }

  buildNoNetworkContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: EmptyStateContent(
        captionText: "No Network",
        hintText: "Please connect to continue viewing your post",
        buttonText: "Retry",
        onButtonClicked: () {
          initalizeNeededData();
        },
      ),
    );
  }

  buildErrorContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: EmptyStateContent(
        captionText: "Something Went Wrong",
        hintText: "Something went wrong in fetching data",
        buttonText: "Retry",
        onButtonClicked: () {
          initalizeNeededData();
        },
      ),
    );
  }

  renderBody(List<Product> favorites, User postCreator) {
    return BlocBuilder<RefreshProductCubit, RefreshProductState>(
        builder: (context, state) {
      if (state is RefreshPostLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is RefreshPostError) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).postDetailRefreshError,
              ),
            ),
          );
        });
      }

      if (state is RefreshPostNoNetwork) {
        return buildNoNetworkContent();
      }

      if (state is RefreshPostSuccessfull) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            product = state.product;
          });
        });
      }
      var duplicate = favorites.where((e) => e.id == product!.id).toList();
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: PostContentToShow(
          isFavorite: duplicate.isNotEmpty,
          handleSaveToFavorite: () => updateFavorites(favorites, product!),
          product: product!,
          currentUser: currentUser!,
          authToken: authToken!,
          postCreator: postCreator,
        ),
      );
    });
  }

  renderAppBar() {
    return PostDetailAppBar(
      onAppBarMenuClicked: (value) => handleAppBarMenuClicked(value),
      showActions: product != null && currentUser!.id == product!.createdBy,
    );
  }

  User? getCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      return authState.currentUser;
    }
    return null;
  }

  String? getToken() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      return authState.loginResult.token;
    }
    return null;
  }

  handleAppBarMenuClicked(String value) {
    List<String> values = [
      AppLocalizations.of(context).postDetailEditText,
      AppLocalizations.of(context).postDetailRefreshText,
      AppLocalizations.of(context).postDetailDeleteText,
    ];

    if (value == values[0]) {
      Navigator.pushReplacementNamed(
        context,
        EditPostPage.routeName,
        arguments: product,
      );
    } else if (value == values[1]) {
      refreshProduct(product!);
    } else if (value == values[2]) {
      deleteProduct(product!);
    }
  }

  void updateFavorites(List<Product> favoriteProducts, Product product) {
    var duplicate = favoriteProducts.where((e) => e.id == product.id).toList();
    List<ProductModel> favoritesToSave = [];
    if (duplicate.isEmpty) {
      favoritesToSave = buildListWithProductAdded(favoriteProducts, product);
    } else {
      favoritesToSave = buildListWithProductRemoved(favoriteProducts, product);
    }
    context
        .read<SetFavoriteProductsCubit>()
        .setFavoriteProducts
        .call(favoritesToSave);
    context
        .read<GetPostDetailContentCubit>()
        .execute(product.createdBy, authToken!);
  }

  List<ProductModel> buildListWithProductRemoved(
    List<Product> favoriteProducts,
    Product product,
  ) {
    var removed = favoriteProducts.where((e) => e.id != product.id).toList();
    return removed.map((e) => ProductModel.fromProduct(e)).toList();
  }

  List<ProductModel> buildListWithProductAdded(
      List<Product> favoriteProducts, Product product) {
    return [...favoriteProducts, product]
        .map((e) => ProductModel.fromProduct(e))
        .toList();
  }

  void refreshProduct(Product product) {
    context.read<RefreshProductCubit>().call(product.id, authToken!);
  }

  void deleteProduct(Product product) {
    context.read<DeleteProductByIdCubit>().call(product.id, authToken!);
    Navigator.pop(context);
  }
}
