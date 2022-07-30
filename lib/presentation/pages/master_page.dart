import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mnale_client/core/services/network_info.dart';

import '../../domain/enitites/conversation.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_all_conversations/get_all_conversations_cubit.dart';
import 'add_post_page.dart';
import 'chat_list_page.dart';
import 'home_page.dart';
import 'offline_page.dart';
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
  ConnectivityResult _source = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  dynamic networkStream;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    networkStream =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult source) {
      setState(() => _source = source);
      checkConnection();
    });
  }

  @override
  void dispose() {
    super.dispose();
    networkStream.cancel();
  }

  List<Widget> pagesToShow = [
    const HomePage(),
    const ChatListPage(),
    const AddPostPage(),
    const SavedPostsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getAllConversation() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<GetAllConversationsCubit>().call(authState.currentUser.id);
    }
  }

  Future<void> checkConnection() async {
    switch (_source) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        var result = await NetworkInfo().isConnected();
        setState(() {
          isConnected = result;
        });
        break;
      case ConnectivityResult.none:
      default:
        setState(() {
          isConnected = false;
        });
        Navigator.of(context).pushReplacementNamed(OfflinePage.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagesToShow.elementAt(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.pentagon_rounded,
                size: 28,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextOne,
            ),
            renderChatItem(context),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.all_inbox,
                size: 28,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextThree,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.save,
                size: 28,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextFour,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.settings,
                size: 28,
              ),
              label: AppLocalizations.of(context).masterNavigationBarTextFive,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF141313),
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  BottomNavigationBarItem renderChatItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: BlocBuilder<GetAllConversationsCubit, Stream<List<Conversation>>>(
        builder: (context, conversationStream) {
          return StreamBuilder<List<Conversation>>(
            stream: conversationStream,
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Icon(
                  Icons.chat,
                  size: 25,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Icon(
                  Icons.chat,
                  size: 25,
                );
              }

              int unreadMessagesCount = buildUnreadMessages(snapshot.data);
              return Stack(
                children: [
                  const Icon(
                    Icons.chat,
                    size: 25,
                  ),
                  Visibility(
                    visible: unreadMessagesCount > 0,
                    child: Positioned(
                      top: 2,
                      left: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 6.5,
                        child: Center(
                          child: Text(
                            unreadMessagesCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      label: AppLocalizations.of(context).masterNavigationBarTextTwo,
    );
  }

  int buildUnreadMessages(List<Conversation>? data) {
    var totalUnreadMessagesCount = 0;
    for (var conversation in data!) {
      var unreadMessagesInConversation =
          conversation.messages.where((m) => !m.isSeen).toList();
      totalUnreadMessagesCount += unreadMessagesInConversation.length;
    }

    return totalUnreadMessagesCount;
  }
}
