import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_all_conversations/get_all_conversations_cubit.dart';
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

  @override
  void initState() {
    super.initState();
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<GetAllConversationsCubit>().call(
            authState.currentUser.id,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagesToShow.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.pentagon_rounded,
              size: 28,
            ),
            label: AppLocalizations.of(context).masterNavigationBarTextOne,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: const [
                Icon(
                  Icons.chat,
                  size: 25,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 7,
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            label: AppLocalizations.of(context).masterNavigationBarTextTwo,
          ),
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
    );
  }
}
