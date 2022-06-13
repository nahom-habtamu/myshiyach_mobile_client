import '../../data/models/conversation/add_conversation_model.dart';
import '../contracts/conversation_service.dart';
import '../enitites/conversation.dart';

class CreateConversation {
  final ConversationService repository;

  CreateConversation(this.repository);

  Future<Conversation> call(AddConversationModel addConversationModel) {
    return repository.createConversation(addConversationModel);
  }
}
