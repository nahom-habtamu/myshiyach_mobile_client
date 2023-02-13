import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mnale_client/presentation/pages/post_detail_page.dart';

import '../../domain/enitites/conversation.dart';
import '../../domain/enitites/login_result.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_all_conversations/get_all_conversations_cubit.dart';
import '../bloc/get_all_conversations/get_all_conversations_state.dart';
import '../bloc/get_product_by_id/get_product_by_id_cubit.dart';
import '../screen_arguments/post_detail_page_arguments.dart';
import 'add_post_page.dart';
import 'chat_list_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'saved_posts.dart';

class MasterPage extends StatefulWidget {
  static String routeName = "/masterPage";
  const MasterPage({Key? key}) : super(key: key);

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int _selectedIndex = 0;
  User? currentUser;
  LoginResult? loginResult;

  PostDetalPageArguments? postDetalPageArguments;

  List<Widget> pagesToShow = [
    const HomePage(),
    const ChatListPage(),
    const AddPostPage(),
    const SavedPostsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getAllConversation();
    initializePostDetailArgsAndNavigateToPostDetailPageIfItHasValue();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      handleDynamicLink(context);
    });
  }

  void initializePostDetailArgsAndNavigateToPostDetailPageIfItHasValue() {
    Future.delayed(Duration.zero, () {
      var args =
          ModalRoute.of(context)!.settings.arguments as PostDetalPageArguments?;

      if (args != null) {
        setState(() {
          postDetalPageArguments = args;
        });
      }
    });
  }

  void handleDynamicLink(context) {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty && mounted) {
        handleFetchingProductAndNavigateToProductDetail(
          context,
          dynamicLinkData,
        );
      }
    });
  }

  void handleFetchingProductAndNavigateToProductDetail(
    BuildContext context,
    PendingDynamicLinkData linkData,
  ) async {
    var productId = linkData.link.queryParameters["productId"];
    var product = await context
        .read<GetProductByIdCubit>()
        .call(productId!, loginResult!.token);

    if (product != null) {
      setState(() {
        postDetalPageArguments = PostDetalPageArguments(
          product: product,
          isFromDynamicLink: true,
          currentUser: currentUser,
          token: loginResult!.token,
        );
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      postDetalPageArguments = null;
    });
  }

  void getCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      setState(() {
        currentUser = authState.currentUser;
        loginResult = authState.loginResult;
      });
    }
  }

  void getAllConversation() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<GetAllConversationsCubit>().call(authState.currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: postDetalPageArguments != null
          ? PostDetailPage(args: postDetalPageArguments!)
          : pagesToShow.elementAt(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 55,
        child: BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 25,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.pentagon_rounded,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextOne,
            ),
            renderChatItem(context),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.add_box,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextThree,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.save,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextFour,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.settings,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextFive,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: postDetalPageArguments == null ?const Color(0xFF141313) : Colors.grey,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  BottomNavigationBarItem renderChatItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: BlocBuilder<GetAllConversationsCubit, GetAllConversationsState>(
        builder: (context, conversationStream) {
          if (conversationStream is GetAllConversationStateLoaded) {
            return StreamBuilder<List<Conversation>>(
              stream: conversationStream.conversation,
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const Icon(
                    Icons.chat,
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Icon(
                    Icons.chat,
                  );
                }

                int unreadMessagesCount = buildUnreadMessages(snapshot.data);
                return renderChatBarWithMessageIndicator(
                  unreadMessagesCount,
                );
              },
            );
          } else {
            return const Icon(
              Icons.chat,
            );
          }
        },
      ),
      label: AppLocalizations.of(context).masterNavigationBarTextTwo,
    );
  }

  Stack renderChatBarWithMessageIndicator(int unreadMessagesCount) {
    return Stack(
      children: <Widget>[
        const Icon(Icons.chat),
        Visibility(
          visible: unreadMessagesCount > 0,
          child: Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                unreadMessagesCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }

  int buildUnreadMessages(List<Conversation>? data) {
    var totalUnreadMessagesCount = 0;
    for (var conversation in data!) {
      var unreadMessagesInConversation = conversation.messages
          .where((m) => !m.isSeen && m.recieverId == currentUser!.id)
          .toList();
      if (unreadMessagesInConversation.isNotEmpty) totalUnreadMessagesCount++;
    }

    return totalUnreadMessagesCount;
  }
}
