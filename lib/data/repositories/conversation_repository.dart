import '../../domain/contracts/conversation_service.dart';
import '../datasources/conversation/conversation_data_source.dart';
import '../models/conversation/message_model.dart';
import '../models/conversation/conversation_model.dart';
import '../models/conversation/add_conversation_model.dart';

class ConversationRepository extends ConversationService {
  final ConversationDataSource remoteDataSource;

  ConversationRepository(this.remoteDataSource);

  @override
  Stream<List<ConversationModel>> getAllConversations(String currentUserId) {
    return remoteDataSource.getAllConversations(currentUserId);
  }

  @override
  void addMessageToConversation(
      String conversationId, MessageModel messageToAdd) {
    remoteDataSource.addMessageToConversation(conversationId, messageToAdd);
  }

  @override
  Stream<ConversationModel> getConversationById(String id) {
    return remoteDataSource.getConversationById(id);
  }

  @override
  Future<ConversationModel> createConversation(AddConversationModel addConversationModel) {
    return remoteDataSource.createConversation(addConversationModel);
  }

  @override
  Stream<ConversationModel> getConversationByMembers(
    String memberOneId,
    String memberTwoId,
  ) {
    return remoteDataSource.getConversationByMembers(memberOneId, memberTwoId);
  }
}
