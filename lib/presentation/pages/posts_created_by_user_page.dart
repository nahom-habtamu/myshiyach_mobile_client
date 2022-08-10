import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/enitites/product.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_products_by_user_id/get_products_by_user_id_cubit.dart';
import '../bloc/get_products_by_user_id/get_products_by_user_id_state.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/common/post_card_list_item.dart';
import 'add_post_page.dart';

class PostsCreatedByUserPage extends StatefulWidget {
  static String routeName = '/postsCreatedByUserPage';
  const PostsCreatedByUserPage({Key? key}) : super(key: key);

  @override
  State<PostsCreatedByUserPage> createState() => _PostsCreatedByUserPageState();
}

class _PostsCreatedByUserPageState extends State<PostsCreatedByUserPage> {
  String accessToken = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    initAccessToken();

    Future.delayed(Duration.zero, () {
      // userId = ModalRoute.of(context)!.settings.arguments as String;
      userId = "62c0275cdefbcb53a9fd53a1";
      fetchPostsCreatedByUser(userId);
    });
  }

  void initAccessToken() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
    }
  }

  void fetchPostsCreatedByUser(String userId) {
    context.read<GetProductsByUserIdCubit>().call(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).postsCreatedByUserPageAppBarText,
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
      captionText:
          AppLocalizations.of(context).postsCreatedByUserPageEmptyCaptionText,
      hintText:
          AppLocalizations.of(context).postsCreatedByUserPageEmptyHintText,
      buttonText:
          AppLocalizations.of(context).postsCreatedByUserPageEmptyButtonText,
      onButtonClicked: () {
        Navigator.pushReplacementNamed(context, AddPostPage.routeName);
      },
    );
  }

  buildNoNetworkContent() {
    return NoNetworkContent(
      onButtonClicked: () => fetchPostsCreatedByUser(userId),
    );
  }

  buildErrorContent() {
    return ErrorContent(
      onButtonClicked: () => fetchPostsCreatedByUser(userId),
    );
  }

  buildProductList(List<Product> products) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => PostCardListItem(
          product: products[index],
        ),
        itemCount: products.length,
      ),
    );
  }
}
