import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  static String routeName = "/chatPage";
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('I AM CHAT LIST PAGE'),
        ),
      ),
    );
  }
}
