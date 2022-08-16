import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_user_and_products_by_user_id/get_user_and_products_by_user_id_cubit.dart';
import '../bloc/get_user_and_products_by_user_id/get_user_and_products_by_user_id_state.dart';
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
      userId = ModalRoute.of(context)!.settings.arguments as String;
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
    context.read<GetUserAndProductsByUserIdCubit>().call(userId, accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).postsCreatedByUserPageAppBarText,
      ),
      body: CurvedContainer(
        child: renderBody(),
      ),
    );
  }

  renderBody() {
    return BlocBuilder<GetUserAndProductsByUserIdCubit,
        GetUserAndProductsByUserIdState>(
      builder: (context, state) {
        if (state is GetUserAndProductsByUserIdLoaded) {
          return buildProductListAndHeader(state.products, state.user);
        } else if (state is GetUserAndProductsByUserIdLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetUserAndProductsByUserIdError) {
          return buildErrorContent();
        } else if (state is GetUserAndProductsByUserIdNoNetwork) {
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

  buildProductListAndHeader(List<Product> products, User user) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          color: Colors.red,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => PostCardListItem(
              product: products[index],
            ),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}
