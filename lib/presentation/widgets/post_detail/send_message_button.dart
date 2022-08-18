import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/conversation/add_conversation_model.dart';
import '../../../domain/enitites/user.dart';
import '../../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../../bloc/handle_going_to_message/handle_going_to_message_state.dart';
import '../../pages/chat_detail_page.dart';
import '../common/action_button.dart';

class SendMessageButton extends StatelessWidget {
  final User currentUser;
  final String receiverId;
  final String authToken;

  const SendMessageButton({
    Key? key,
    required this.currentUser,
    required this.receiverId,
    required this.authToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: currentUser.id != receiverId,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<HandleGoingToMessageCubit, HandleGoingToMessageState>(
              builder: (context, state) {
                if (state is HandleGoingToMessageLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is HandleGoingToMessageSuccessfull) {
                  context.read<GetConversationByIdCubit>().call(
                        state.chatDetailPageArguments.conversationId,
                      );
                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(
                      context,
                      ChatDetailPage.routeName,
                      arguments: state.chatDetailPageArguments,
                    );
                  });
                }
                return ActionButton(
                  onPressed: () {
                    var addConversation = AddConversationModel(
                      memberOne: currentUser.id,
                      memberTwo: receiverId,
                    );
                    context.read<HandleGoingToMessageCubit>().call(
                          addConversation,
                          currentUser.id,
                          authToken,
                        );
                  },
                  text:
                      AppLocalizations.of(context).postDetailSendMessageButton,
                  isCurved: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
