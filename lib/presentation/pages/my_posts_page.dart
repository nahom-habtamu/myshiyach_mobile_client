import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/enitites/product.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/get_products_by_user_id/get_products_by_user_id_cubit.dart';
import '../bloc/get_products_by_user_id/get_products_by_user_id_state.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/common/post_card_list_item.dart';
import 'add_post_page.dart';

class MyPostsPage extends StatefulWidget {
  static String routeName = '/myPostsPage';
  const MyPostsPage({Key? key}) : super(key: key);

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  String accessToken = "";

  @override
  void initState() {
    super.initState();
    initAccessToken();
    fetchMyPosts();
  }

  void initAccessToken() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
    }
  }

  void fetchMyPosts() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<GetProductsByUserIdCubit>().call(authState.currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).myPostsPageAppBarText,
      ),
      body: CurvedContainer(
        child: buildMyPosts(),
      ),
    );
  }

  buildMyPosts() {
    return BlocBuilder<GetProductsByUserIdCubit, GetProductsByUserIdState>(
      builder: (context, state) {
        if (state is GetProductsByUserIdLoaded) {
          return buildProductList(state.products);
        } else if (state is GetProductsByUserIdLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetProductsByUserIdError) {
          return buildErrorContent();
        } else if (state is GetProductsByUserIdNoNetwork) {
          return buildNoNetworkContent();
        } else {
          return buildEmptyStateContent();
        }
      },
    );
  }

  buildEmptyStateContent() {
    return FallBackContent(
      captionText: AppLocalizations.of(context).myPostsPageEmptyCaptionText,
      hintText: AppLocalizations.of(context).myPostsPageEmptyHintText,
      buttonText: AppLocalizations.of(context).myPostsPageEmptyButtonText,
      onButtonClicked: () {
        Navigator.pushReplacementNamed(context, AddPostPage.routeName);
      },
    );
  }

  buildNoNetworkContent() {
    return NoNetworkContent(
      onButtonClicked: () => fetchMyPosts(),
    );
  }

  buildErrorContent() {
    return ErrorContent(
      onButtonClicked: () => fetchMyPosts(),
    );
  }

  buildProductList(List<Product> products) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            AppLocalizations.of(context).myPostsPageSwipeToDelete,
            style: const TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => PostCardListItem(
              product: products[index],
              onDissmissed: (product) {
                context.read<DeleteProductByIdCubit>().call(
                      product.id,
                      accessToken,
                    );
                fetchMyPosts();
              },
            ),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}
