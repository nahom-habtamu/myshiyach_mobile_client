import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../domain/enitites/conversation.dart';
import '../../../domain/enitites/user.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../../bloc/get_user_by_id/get_user_by_id_cubit.dart';
import '../../bloc/get_user_by_id/get_user_by_id_state.dart';
import '../../pages/chat_detail_page.dart';
import '../../screen_arguments/chat_detail_page_arguments.dart';

class ConversationItem extends StatefulWidget {
  final Conversation conversation;
  const ConversationItem({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  User? strangerUser;
  String? currentUserId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getStrangerInformation();
    });
  }

  void getStrangerInformation() async {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      var strangerId = getStrangerId(authState);
      var token = authState.loginResult.token;
      setState(() {
        currentUserId = authState.currentUser.id;
      });
      if (context.read<GetUserByIdCubit>().state is! GetUserByIdLoaded) {
        var stranger =
            await context.read<GetUserByIdCubit>().call(strangerId, token);
        setState(() {
          strangerUser = stranger;
        });
      }
    }
  }

  String getStrangerId(AuthSuccessfull authState) {
    var memberOne = widget.conversation.memberOne;
    var memberTwo = widget.conversation.memberTwo;
    var strangerId =
        authState.currentUser.id == memberOne ? memberTwo : memberOne;
    return strangerId;
  }

  @override
  Widget build(BuildContext context) {
    return strangerUser == null ? renderLoadingWidget() : renderMainContent();
  }

  renderMainContent() {
    var unreadMessages = widget.conversation.messages
        .where((m) => !m.isSeen && m.recieverId == currentUserId)
        .toList();
    return GestureDetector(
      onTap: () {
        context.read<GetConversationByIdCubit>().call(widget.conversation.id);
        var chatDetailPageArguments = ChatDetailPageArguments(
          conversationId: widget.conversation.id,
          strangerUser: strangerUser!,
        );
        Navigator.of(context).pushNamed(
          ChatDetailPage.routeName,
          arguments: chatDetailPageArguments,
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 5,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 35,
                child: Text(strangerUser!.fullName[0].toUpperCase()),
              ),
              Expanded(
                child: ListTile(
                  title: Text(strangerUser!.fullName),
                  subtitle: SizedBox(
                    height: 50,
                    width: 200,
                    child: Text(
                      widget.conversation.messages.isEmpty
                          ? ""
                          : widget.conversation.messages.last.text,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.conversation.messages.isEmpty
                          ? ""
                          : DateFormatterUtil.extractTimeFromDate(
                              widget.conversation.messages.last.createdDateTime,
                            ),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Visibility(
                    visible: unreadMessages.isNotEmpty,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 9,
                      child: Center(
                        child: Text(
                          unreadMessages.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget renderLoadingWidget() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 100,
        child: Center(
          child: Text(AppLocalizations.of(context).chatListFetchLoadingText),
        ),
      ),
    );
  }
}
