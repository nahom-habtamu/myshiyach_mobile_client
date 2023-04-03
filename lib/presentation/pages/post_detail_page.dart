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
import '../bloc/report_product/report_product_cubit.dart';
import '../bloc/update_favorite_products/update_favorite_products_cubit.dart';
import '../screen_arguments/post_detail_page_arguments.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/common/pop_up_dialog.dart';
import '../widgets/post_detail/post_content_to_show.dart';
import '../widgets/post_detail/post_detail_app_bar.dart';
import 'edit_post_page.dart';

class PostDetailPage extends StatefulWidget {
  final PostDetalPageArguments args;
  static String routeName = "/postDetail";
  const PostDetailPage({Key? key, required this.args}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Product? product;
  User? currentUser;
  String? authToken;
  bool isFromDynamicLink = false;
  List<Product> favorites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initalizeNeededData();
    });
  }

  void initalizeNeededData() {
    setState(() {
      currentUser = getCurrentUser() ?? widget.args.currentUser;
      authToken = getToken() ?? widget.args.token;
      product = widget.args.product;
      isFromDynamicLink = widget.args.isFromDynamicLink;
    });
    context.read<HandleGoingToMessageCubit>().clear();
    context.read<RefreshProductCubit>().clear();
    context.read<GetPostDetailContentCubit>().execute(
          widget.args.product.createdBy,
          currentUser!.id,
          authToken!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              if (favorites.isEmpty) {
                setState(() {
                  favorites = [...state.favoriteProducts];
                });
              }
              // context.read<GetPostDetailContentCubit>().clear();
            });
            return renderBody(state.postCreator);
          }
          return Container();
        },
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

  renderBody(User postCreator) {
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
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: PostContentToShow(
            isFavorite: duplicate.isNotEmpty,
            handleSaveToFavorite: () => updateFavorites(product!),
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

  handleAppBarMenuClicked(String value) async {
    List<String> values = [
      AppLocalizations.of(context).postDetailEditText,
      AppLocalizations.of(context).postDetailRefreshText,
      AppLocalizations.of(context).postDetailDeleteText,
      AppLocalizations.of(context).postDetailShareText,
      AppLocalizations.of(context).postDetailReportText,
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
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupDialog(
            content:
                AppLocalizations.of(context).savedPostsDeleteConfirmDialogText,
          );
        },
      );
      if (result) {
        deleteProduct(product!);
      }
    } else if (value == values[3]) {
      handleProductShare(product!.id);
    } else if (value == values[4]) {
      handleProductReport(product!.id);
    }
  }

  void updateFavorites(Product product) {
    var duplicate = favorites.where((e) => e.id == product.id).toList();
    List<ProductModel> favoritesToSave = [];
    if (duplicate.isEmpty) {
      favoritesToSave = buildListWithProductAdded(favorites, product);
    } else {
      favoritesToSave = buildListWithProductRemoved(favorites, product);
    }
    setState(() {
      favorites = favoritesToSave;
    });
    context.read<AuthCubit>().updateFavoriteProducts(
          authToken!,
          currentUser!,
          favoritesToSave.map((e) => e.id).toList(),
        );
    context.read<UpdateFavoriteProductsCubit>().updateFavoriteProducts.call(
          currentUser!.id,
          authToken!,
          favoritesToSave.map((e) => e.id).toList(),
        );
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
    return [product, ...favoriteProducts]
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

  void handleProductReport(String id) async {
    context.read<ReportProductCubit>().call(id, authToken!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).postDetailReportSuccessText),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
