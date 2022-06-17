import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/conversation.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_all_conversations/get_all_conversations_cubit.dart';
import '../widgets/chat_list/conversation_item.dart';

class ChatListPage extends StatefulWidget {
  static String routeName = "/chatPage";
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var authState = context.read<AuthCubit>().state;

      if (authState is AuthSuccessfull) {
        context.read<GetAllConversationsCubit>().call(
              authState.currentUser.id,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat List Page',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(
            top: 25,
            left: 25,
            right: 25,
          ),
          width: MediaQuery.of(context).size.width,
          child:
              BlocBuilder<GetAllConversationsCubit, Stream<List<Conversation>>>(
            builder: (context, conversations) {
              return buildConversationList(conversations);
            },
          ),
        ),
      ),
    );
  }

  Widget buildConversationList(Stream<List<Conversation>> conversationStream) {
    return StreamBuilder<List<Conversation>>(
      stream: conversationStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No chats found!!'));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children:
              snapshot.data!.map((e) => buildConversationItem(e)).toList(),
        );
      },
    );
  }

  Widget buildConversationItem(Conversation conversation) {
    return ConversationItem(
      conversation: conversation,
    );
  }
}
