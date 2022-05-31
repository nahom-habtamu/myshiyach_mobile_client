import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/conversation.dart';
import '../bloc/get_all_conversations/get_all_conversations_cubit.dart';

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
      context.read<GetAllConversationsCubit>().call();
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
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
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
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 100,
        child: Row(
          children: const [
             Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 45,
                child: Text("AB"),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('title'),
                subtitle: Text('last message in convo'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
