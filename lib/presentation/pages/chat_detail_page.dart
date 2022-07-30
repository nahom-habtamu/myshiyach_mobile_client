import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/date_time_formatter.dart';
import '../../data/models/conversation/message_model.dart';
import '../../domain/enitites/conversation.dart';
import '../../domain/enitites/message.dart';
import '../../domain/enitites/user.dart';
import '../bloc/add_message_to_conversation/add_message_to_conversation_cubit.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../bloc/mark_messages_as_read/mark_messages_as_read_cubit.dart';
import '../screen_arguments/chat_detail_page_arguments.dart';
import '../widgets/chat_detail/message_bubble.dart';
import '../widgets/chat_detail/message_sending_tab.dart';
import '../widgets/chat_detail/stanger_user_info.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';

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

  @override
  void initState() {
    super.initState();
    initializeCurrentUser();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        backgroundColor: const Color(0xff11435E),
        appBar: CustomAppBar(
          title: AppLocalizations.of(context).chatDetailAppBarText,
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
          return Text(AppLocalizations.of(context).chatDetailFetchError);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        markAllMessagesAsRead(snapshot.data!);
        return renderMainContent(snapshot.data!);
      },
    );
  }

  void markAllMessagesAsRead(Conversation conversation) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<MarkMessagesAsReadCubit>()
          .call(currentUser!.id, conversation);
    });
  }

  renderMainContent(Conversation conversation) {
    return CurvedContainer(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: Column(
        children: [
          renderChatDetailStrangerInfo(),
          Container(
            height: 1,
            color: Colors.black12,
          ),
          renderMessageBubblesAlongWithCreatedDate(conversation),
          renderMessageSendingTab(conversation)
        ],
      ),
    );
  }

  bool compareMessageSentDate(String uniqueDate, String messageCreatedDate) {
    return DateFormatterUtil.compareDates(uniqueDate, messageCreatedDate);
  }

  renderMessageBubblesAlongWithCreatedDate(Conversation conversation) {
    var uniqueDates = buildUniqueDateFromMessages(conversation);
    var generatedWidgets = List<ListTile>.generate(uniqueDates.length, (index) {
      var messagesWithCurrentDate = conversation.messages
          .where(
            (m) => compareMessageSentDate(uniqueDates[index],
                DateFormatterUtil.extractDateFromDateTime(m.createdDateTime)),
          )
          .toList();
      return ListTile(
        title: Container(
          height: 20,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Text(
            DateFormatterUtil.formatUniqueMessageCreatedDate(
                uniqueDates[index]),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        subtitle: renderMessageBubbles(messagesWithCurrentDate),
      );
    });

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: ((context, index) => generatedWidgets[index]),
        itemCount: generatedWidgets.length,
      ),
    );
  }

  List<String> buildUniqueDateFromMessages(Conversation conversation) {
    return conversation.messages
        .map(
            (e) => DateFormatterUtil.extractDateFromDateTime(e.createdDateTime))
        .toSet()
        .toList();
  }

  renderMessageSendingTab(Conversation conversation) {
    return MessageSendingTab(
      onMessageChanged: (value) => setState(() => messageContent = value),
      onMessageSend: () => handleAddingMessage(),
    );
  }

  void handleAddingMessage() async {
    if (messageContent.isNotEmpty) {
      var messageToAdd = MessageModel(
        text: messageContent,
        senderId: currentUser!.id,
        recieverId: args!.strangerUser.id,
        createdDateTime: DateTime.now().toIso8601String(),
        isSeen: false,
      );
      context
          .read<AddMessageToConversationCubit>()
          .call(args!.conversationId, messageToAdd);
      await handleScrollingToBottom();
    }
  }

  Future<void> handleScrollingToBottom() async {
    await Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  renderChatDetailStrangerInfo() {
    return StrangerUserInfo(strangerUser: args!.strangerUser);
  }

  renderMessageBubbles(List<Message> messages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => MessageBubble(
          message: messages[index],
          strangerId: args!.strangerUser.id,
          isSentByCurrentUser:
              messages[index].senderId == args!.strangerUser.id,
        ),
        itemCount: messages.length,
      ),
    );
  }
}
