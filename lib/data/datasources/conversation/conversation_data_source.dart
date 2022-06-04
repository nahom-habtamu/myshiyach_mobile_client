import 'package:mnale_client/data/models/conversation/add_conversation_model.dart';

import '../../models/conversation/conversation_model.dart';
import '../../models/conversation/message_model.dart';

abstract class ConversationDataSource {
  Stream<List<ConversationModel>> getAllConversations();
  Stream<ConversationModel> getConversationById(String id);
  Stream<ConversationModel> getConversationByMembers(String memberOneId, String memberTwoId);
  void addMessageToConversation(
    String conversationId,
    MessageModel messageToAdd,
  );
  Future<ConversationModel> createConversation(AddConversationModel addConversationModel);
}
