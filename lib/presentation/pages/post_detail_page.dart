import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/generate_share_link_for_product/generate_share_link_for_product_cubit.dart';
import '../bloc/get_post_detail_content/get_post_detail_content_cubit.dart';
import '../bloc/get_post_detail_content/get_post_detail_content_state.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../bloc/refresh_product/refresh_product_cubit.dart';
import '../bloc/refresh_product/refresh_product_state.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../screen_arguments/post_detail_page_arguments.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/post_detail/post_content_to_show.dart';
import '../widgets/post_detail/post_detail_app_bar.dart';
import 'edit_post_page.dart';
import 'master_page.dart';

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
  bool isFromDynamicLink = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initalizeNeededData();
    });
  }

  void initalizeNeededData() {
    var args =
        ModalRoute.of(context)!.settings.arguments as PostDetalPageArguments;
    setState(() {
      currentUser = getCurrentUser() ?? args.currentUser;
      authToken = getToken() ?? args.token;
      product = args.product;
      isFromDynamicLink = args.isFromDynamicLink;
    });
    context.read<HandleGoingToMessageCubit>().clear();
    context.read<RefreshProductCubit>().clear();
    context
        .read<GetPostDetailContentCubit>()
        .execute(product!.createdBy, authToken!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isFromDynamicLink) {
          Navigator.pushReplacementNamed(context, MasterPage.routeName);
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: renderAppBar(),
          body:
              BlocBuilder<GetPostDetailContentCubit, GetPostDetailContentState>(
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
      ),
    );
  }

  buildNoNetworkContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: NoNetworkContent(
        onButtonClicked: () => initalizeNeededData(),
      ),
    );
  }

  buildErrorContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ErrorContent(
        onButtonClicked: () => initalizeNeededData(),
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
        SchedulerBinding.instance!.addPostFrameCallback((_) {
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
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            product = state.product;
          });
        });
      }
      var duplicate = favorites.where((e) => e.id == product!.id).toList();
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: PostContentToShow(
            isFavorite: duplicate.isNotEmpty,
            handleSaveToFavorite: () => updateFavorites(favorites, product!),
            product: product!,
            currentUser: currentUser!,
            authToken: authToken!,
            postCreator: postCreator,
          ),
        ),
      );
    });
  }

  renderAppBar() {
    return PostDetailAppBar(
      onAppBarMenuClicked: (value) => handleAppBarMenuClicked(value),
      showActions: currentUser != null &&
          product != null &&
          currentUser!.id == product!.createdBy,
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
      AppLocalizations.of(context).postDetailShareText,
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
    } else if (value == values[3]) {
      handleProductShare(product!.id);
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

  void handleProductShare(String id) async {
    var content =
        await context.read<GenerateShareLinkForProductCubit>().call(id);
    if (content != null) {
      Share.share(content);
    }
  }
}
