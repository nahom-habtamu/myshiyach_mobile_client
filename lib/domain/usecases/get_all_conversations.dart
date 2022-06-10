import '../contracts/conversation_service.dart';
import '../enitites/conversation.dart';

class GetAllConversations {
  final ConversationService repository;

  GetAllConversations(this.repository);

  Stream<List<Conversation>> call(String currentUserId) {
    var parsedResult = repository.getAllConversations(currentUserId);
    return parsedResult;
  }
}
