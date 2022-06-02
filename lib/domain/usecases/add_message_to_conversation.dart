import '../../data/models/conversation/message_model.dart';
import '../contracts/conversation_service.dart';

class AddMessageToConversation {
  final ConversationService repository;

  const AddMessageToConversation(this.repository);

  void call(String conversationId, MessageModel messageToAdd) {
    repository.addMessageToConversation(
      conversationId,
      messageToAdd,
    );
  }
}
