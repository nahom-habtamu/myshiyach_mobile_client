import '../../models/conversation/conversation_model.dart';

abstract class ConversationDataSource {
  Stream<List<ConversationModel>> getAllConversations();
}
