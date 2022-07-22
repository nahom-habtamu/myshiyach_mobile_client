import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagesToShow.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.pentagon_rounded),
            label: AppLocalizations.of(context).masterNavigationBarTextOne,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: AppLocalizations.of(context).masterNavigationBarTextTwo,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.all_inbox),
            label: AppLocalizations.of(context).masterNavigationBarTextThree,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.save),
            label: AppLocalizations.of(context).masterNavigationBarTextFour,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
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
