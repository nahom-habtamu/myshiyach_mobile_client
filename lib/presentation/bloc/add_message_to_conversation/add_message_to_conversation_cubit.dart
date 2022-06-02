import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/conversation/message_model.dart';
import '../../../domain/usecases/add_message_to_conversation.dart';

class AddMessageToConversationCubit extends Cubit<void> {
  final AddMessageToConversation addMessageToConversation;

  AddMessageToConversationCubit(this.addMessageToConversation)
      : super(const Stream.empty());

  void call(String conversationId, MessageModel messageToAdd) {
    addMessageToConversation.call(conversationId, messageToAdd);
  }
}
