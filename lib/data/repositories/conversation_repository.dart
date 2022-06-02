import '../../domain/contracts/conversation_service.dart';
import '../datasources/conversation/conversation_data_source.dart';
import '../models/conversation/conversation_model.dart';
import '../models/conversation/message_model.dart';

class ConversationRepository extends ConversationService {
  final ConversationDataSource remoteDataSource;

  ConversationRepository(this.remoteDataSource);

  @override
  Stream<List<ConversationModel>> getAllConversations() {
    return remoteDataSource.getAllConversations();
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
}
