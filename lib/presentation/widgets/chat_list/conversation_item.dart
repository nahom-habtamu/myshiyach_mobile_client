import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/enitites/conversation.dart';
import '../../pages/chat_detail_page.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/get_user_by_id/get_user_by_id_cubit.dart';
import '../../bloc/get_user_by_id/get_user_by_id_state.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getStrangerInformation();
    });
  }

  void getStrangerInformation() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      var strangerId = getStrangerId(authState);
      var token = authState.loginResult.token;
      context.read<GetUserByIdCubit>().call(strangerId, token);
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
    return BlocBuilder<GetUserByIdCubit, GetUserByIdState>(
      builder: (context, state) {
        if (state is Loaded) {
          return renderMainContent(state);
        } else if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Error) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: Text("EMPTY"),
          );
        }
      },
    );
  }

  GestureDetector renderMainContent(Loaded state) {
    return GestureDetector(
      onTap: () {
        var chatDetailPageArguments = ChatDetailPageArguments(
          conversation: widget.conversation,
          strangerUser: state.user,
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
          height: 100,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 45,
                  child: Text(state.user.fullName[0].toUpperCase()),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(state.user.fullName),
                  subtitle: Text(widget.conversation.messages.last.text),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
