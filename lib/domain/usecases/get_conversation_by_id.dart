import '../contracts/conversation_service.dart';
import '../enitites/conversation.dart';

class GetConversationById {
  final ConversationService repository;

  GetConversationById(this.repository);

  Stream<Conversation> call(String id) {
    var parsedResult = repository.getConversationById(id);
    return parsedResult;
  }
}
