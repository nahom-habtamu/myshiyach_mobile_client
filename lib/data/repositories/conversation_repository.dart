import '../../domain/contracts/conversation_service.dart';
import '../datasources/conversation/conversation_data_source.dart';
import '../models/conversation/conversation_model.dart';

class ConversationRepository extends ConversationService {
  final ConversationDataSource remoteDataSource;

  ConversationRepository(this.remoteDataSource);

  @override
  Stream<List<ConversationModel>> getAllConversations() {
    return remoteDataSource.getAllConversations();
  }
}
