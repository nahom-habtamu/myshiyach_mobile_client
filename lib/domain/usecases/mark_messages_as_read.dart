import 'package:mnale_client/domain/enitites/conversation.dart';

import '../contracts/conversation_service.dart';

class MarkMessagesAsRead {
  final ConversationService repository;

  const MarkMessagesAsRead(this.repository);

  void call(String currentUserId, Conversation conversation) {
    repository.markAllMessagesAsRead(currentUserId,conversation);
  }
}
