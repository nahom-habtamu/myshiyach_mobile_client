import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/conversation/message_model.dart';
import '../../domain/enitites/conversation.dart';
import '../../domain/enitites/message.dart';
import '../../domain/enitites/user.dart';
import '../bloc/add_message_to_conversation/add_message_to_conversation_cubit.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../constants/login_page_constants.dart';
import '../screen_arguments/chat_detail_page_arguments.dart';

class ChatDetailPage extends StatefulWidget {
  static String routeName = '/chatDetailPage';
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  User? currentUser;
  String messageContent = "";
  ChatDetailPageArguments? args;
  final ScrollController _scrollController = ScrollController();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeCurrentUser();
  }

  void initializeCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      currentUser = authState.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    args =
        ModalRoute.of(context)!.settings.arguments as ChatDetailPageArguments;
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
        body: BlocBuilder<GetConversationByIdCubit, Stream<Conversation>>(
          builder: (context, conversationStream) {
            return buildChatDetail(conversationStream);
          },
        ),
      ),
    );
  }

  Widget buildChatDetail(Stream<Conversation> conversationStream) {
    return StreamBuilder<Conversation>(
      stream: conversationStream,
      builder: (BuildContext context, AsyncSnapshot<Conversation> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return renderMainContent(snapshot.data!);
      },
    );
  }

  Container renderMainContent(Conversation conversation) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.only(top: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          renderChatDetailStrangerInfo(),
          Container(
            height: 1,
            color: Colors.black12,
          ),
          renderMessageBubbles(conversation),
          renderMessageSender(conversation)
        ],
      ),
    );
  }

  Padding renderMessageSender(Conversation conversation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                style: loginInputTextStyle.copyWith(fontSize: 14),
                controller: _controller,
                onChanged: (value) => messageContent = value,
                decoration: const InputDecoration(
                  labelText: "Enter Message",
                  border: loginInputEnabledBorder,
                  enabledBorder: loginInputEnabledBorder,
                  focusedBorder: loginInputDisabledBorder,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                ),
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
            ),
            IconButton(
              onPressed: () {
                _controller.clear();
                if (messageContent.isNotEmpty) handleAddingMessage();
              },
              icon: const Icon(
                Icons.send,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleAddingMessage() async {
    var messageToAdd = MessageModel(
      text: messageContent,
      senderId: currentUser!.id,
      recieverId: args!.strangerUser.id,
      createdDateTime: DateTime.now().toIso8601String(),
    );
    context
        .read<AddMessageToConversationCubit>()
        .call(args!.conversationId, messageToAdd);
    await handleScrollingToBottom();
  }

  Future<void> handleScrollingToBottom() async {
    await Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    });
  }

  Row renderChatDetailStrangerInfo() {
    var splittedStrangerName = args!.strangerUser.fullName.split(" ");
    var avatarContent = splittedStrangerName.first[0].toUpperCase() +
        splittedStrangerName.last[0].toUpperCase();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            width: 60,
            height: 60,
            child: Center(
              child: Text(
                avatarContent,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                args!.strangerUser.fullName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                args!.strangerUser.email ?? "no email",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  renderMessageBubbles(Conversation conversation) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemBuilder: (context, index) => renderMessageBubble(
            conversation.messages[index],
            args!.strangerUser.id,
            conversation.messages[index].senderId == args!.strangerUser.id,
          ),
          itemCount: conversation.messages.length,
        ),
      ),
    );
  }

  renderMessageBubble(Message message, String strangerId, bool isSent) {
    return Align(
      alignment:
          isSent ? FractionalOffset.centerLeft : FractionalOffset.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: message.senderId == strangerId
                ? const Color(0xff11435E)
                : Colors.black12,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
                bottomLeft: message.senderId == strangerId
                    ? const Radius.circular(25)
                    : Radius.zero,
                bottomRight: message.senderId != strangerId
                    ? const Radius.circular(25)
                    : Radius.zero),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          child: Center(
            child: Text(
              message.text,
              style: TextStyle(
                color: message.senderId == strangerId
                    ? Colors.white
                    : Colors.black,
                fontSize: 14,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
