import 'package:mnale_client/data/models/conversation/conversation_model.dart';

abstract class ConversationService {
  Stream<List<ConversationModel>> getAllConversations();
}
