import '../contracts/conversation_service.dart';

class MarkMessagesAsRead {
  final ConversationService repository;

  const MarkMessagesAsRead(this.repository);

  void call(String currentUserId, String conversationId) {
    repository.markAllMessagesAsRead(currentUserId,conversationId);
  }
}
