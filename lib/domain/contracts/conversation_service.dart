import '../../data/models/conversation/message_model.dart';
import '../../data/models/conversation/conversation_model.dart';
import '../../data/models/conversation/add_conversation_model.dart';

abstract class ConversationService {
  Stream<List<ConversationModel>> getAllConversations();
  Future<ConversationModel> createConversation(
    AddConversationModel addConversationModel,
  );
  Stream<ConversationModel> getConversationById(String id);
  Stream<ConversationModel> getConversationByMembers(
    String memberOneId,
    String memberTwoId,
  );
  void addMessageToConversation(
    String conversationId,
    MessageModel messageToAdd,
  );
}