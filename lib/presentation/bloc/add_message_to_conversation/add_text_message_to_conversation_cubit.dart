import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/conversation/message_model.dart';
import '../../../domain/usecases/add_message_to_conversation.dart';

class AddTextMessageToConversationCubit extends Cubit<void> {
  final AddMessageToConversation addMessageToConversation;

  AddTextMessageToConversationCubit(this.addMessageToConversation)
      : super(const Stream.empty());

  void call(String conversationId, MessageModel messageToAdd) async {
    return addMessageToConversation.call(conversationId, messageToAdd);
  }
}
