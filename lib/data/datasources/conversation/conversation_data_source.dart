import '../../models/conversation/conversation_model.dart';
import '../../models/conversation/message_model.dart';

abstract class ConversationDataSource {
  Stream<List<ConversationModel>> getAllConversations();
  Stream<ConversationModel> getConversationById(String id);
  void addMessageToConversation(
      String conversationId, MessageModel messageToAdd);
}
