import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/date_time_formatter.dart';
import '../../domain/enitites/conversation.dart';
import '../../domain/enitites/message.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        appBar: CustomAppBar(
          title: AppLocalizations.of(context).chatListAppBarText,
        ),
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
          return Center(
            child: Text(
              AppLocalizations.of(context).chatListFetchFailedError,
            ),
          );
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context).chatListFetchEmpty,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var sortedConvos = [...snapshot.data!];
        sortedConvos.sort(
            ((a, b) => _compareMessages(a.messages.last, b.messages.last)));

        return ListView.builder(
          itemBuilder: (context, index) {
            var conversation = sortedConvos[index];
            return buildConversationItem(conversation);
          },
          itemCount: sortedConvos.length,
        );
      },
    );
  }

  int _compareMessages(Message a, Message b) {
    var firstDate =
        DateFormatterUtil.parseMessageCreatedDate(a.createdDateTime);
    var secondDate =
        DateFormatterUtil.parseMessageCreatedDate(b.createdDateTime);
    return secondDate.compareTo(firstDate);
  }

  Widget buildConversationItem(Conversation conversation) {
    return ConversationItem(
      conversation: conversation,
    );
  }
}
