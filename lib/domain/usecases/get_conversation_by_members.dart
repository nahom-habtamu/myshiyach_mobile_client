import '../contracts/conversation_service.dart';
import '../enitites/conversation.dart';

class GetConversationByMembers {
  final ConversationService repository;

  GetConversationByMembers(this.repository);

  Stream<Conversation> call(String memberOne, String memberTwo) {
    var parsedResult = repository.getConversationByMembers(memberOne, memberTwo);
    return parsedResult;
  }
}
