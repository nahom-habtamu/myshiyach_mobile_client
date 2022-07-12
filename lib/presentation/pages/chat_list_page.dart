import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/conversation.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_all_conversations/get_all_conversations_cubit.dart';
import '../widgets/chat_list/conversation_item.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';

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
        backgroundColor: const Color(0xff11435E),
        appBar: const CustomAppBar(title: "Chat List"),
        body: CurvedContainer(
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
        return ListView.builder(
          itemBuilder: (context, index) {
            var conversation = snapshot.data![index];
            return buildConversationItem(conversation);
          },
          itemCount: snapshot.data!.length,
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
