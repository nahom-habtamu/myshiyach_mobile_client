import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  User? user;

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
      if (context.read<GetUserByIdCubit>().state is! GetUserByIdLoaded) {
        var stranger =
            await context.read<GetUserByIdCubit>().call(strangerId, token);
        setState(() {
          user = stranger;
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
    return user == null ? renderLoadingWidget() : renderMainContent();
  }

  renderMainContent() {
    return GestureDetector(
      onTap: () {
        context.read<GetConversationByIdCubit>().call(widget.conversation.id);
        var chatDetailPageArguments = ChatDetailPageArguments(
          conversationId: widget.conversation.id,
          strangerUser: user!,
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
                child: Text(user!.fullName[0].toUpperCase()),
              ),
              Expanded(
                child: ListTile(
                  title: Text(user!.fullName),
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
        child: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
