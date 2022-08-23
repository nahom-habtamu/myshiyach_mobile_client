import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_user_and_products_by_user_id/get_user_and_products_by_user_id_cubit.dart';
import '../bloc/get_user_and_products_by_user_id/get_user_and_products_by_user_id_state.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/common/post_card_list_item.dart';
import '../widgets/post_detail/detail_item.dart';
import '../widgets/post_detail/send_message_button.dart';
import 'add_post_page.dart';

class PostsCreatedByUserPage extends StatefulWidget {
  static String routeName = '/postsCreatedByUserPage';
  const PostsCreatedByUserPage({Key? key}) : super(key: key);

  @override
  State<PostsCreatedByUserPage> createState() => _PostsCreatedByUserPageState();
}

class _PostsCreatedByUserPageState extends State<PostsCreatedByUserPage> {
  String accessToken = "";
  User? currentUser;
  String userId = "";

  @override
  void initState() {
    super.initState();
    initAccessToken();
    context.read<HandleGoingToMessageCubit>().clear();
    Future.delayed(Duration.zero, () {
      userId = ModalRoute.of(context)!.settings.arguments as String;
      fetchPostsCreatedByUser(userId);
    });
  }

  void initAccessToken() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
      currentUser = authState.currentUser;
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            AppLocalizations.of(context)
                .postsCreatedByUserPageUserInformationText,
            style: const TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: DetailItem(
                  isCurved: true,
                  color: const Color(0xFFDAD9D9),
                  title: Text(
                      AppLocalizations.of(context).postDetailOwnerNameText),
                  subtitle: Text(user.fullName),
                  onClick: () {},
                ),
              ),
              Expanded(
                child: DetailItem(
                  isCurved: true,
                  color: const Color(0xFFDAD9D9),
                  title: Text(AppLocalizations.of(context)
                      .postDetailOwnerPhoneNumberText),
                  subtitle: Text(user.phoneNumber),
                  onClick: () async {
                    final _call = 'tel:${user.phoneNumber}';
                    if (await canLaunchUrl(Uri.parse(_call))) {
                      await launchUrl(Uri.parse(_call));
                    }
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SendMessageButton(
            currentUser: currentUser!,
            receiverId: userId,
            authToken: accessToken,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            AppLocalizations.of(context).postsCreatedByUserPageProductText,
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
            ),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}
