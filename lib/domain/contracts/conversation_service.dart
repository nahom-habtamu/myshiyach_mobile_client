import '../../data/models/conversation/message_model.dart';

import '../../data/models/conversation/conversation_model.dart';

abstract class ConversationService {
  Stream<List<ConversationModel>> getAllConversations();
  Stream<ConversationModel> getConversationById(String id);
  void addMessageToConversation(
      String conversationId, MessageModel messageToAdd);
}
