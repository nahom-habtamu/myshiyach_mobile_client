import 'package:flutter/material.dart';

import '../../domain/enitites/user.dart';
import '../../domain/enitites/message.dart';
import '../constants/login_page_constants.dart';
import '../screen_arguments/chat_detail_page_arguments.dart';

class ChatDetailPage extends StatefulWidget {
  static String routeName = '/chatDetailPage';
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    final args =
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
        body: Container(
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
              renderChatDetailStrangerInfo(args.strangerUser),
              Container(
                height: 1,
                color: Colors.black12,
              ),
              renderMessageBubbles(args),
              renderMessageSender()
            ],
          ),
        ),
      ),
    );
  }

  Padding renderMessageSender() {
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
                onChanged: (value) => {},
                decoration: const InputDecoration(
                    labelText: "Enter Message",
                    border: loginInputEnabledBorder,
                    enabledBorder: loginInputEnabledBorder,
                    focusedBorder: loginInputDisabledBorder,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(18)),
              ),
            ),
            IconButton(
              onPressed: () {},
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

  Row renderChatDetailStrangerInfo(User strangerUser) {
    var splittedStrangerName = strangerUser.fullName.split(" ");
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
                strangerUser.fullName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                strangerUser.email ?? "no email",
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

  renderMessageBubbles(ChatDetailPageArguments args) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => renderMessageBubble(
            args.conversation.messages[index],
            args.strangerUser.id,
            args.conversation.messages[index].senderId == args.strangerUser.id,
          ),
          itemCount: args.conversation.messages.length,
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
