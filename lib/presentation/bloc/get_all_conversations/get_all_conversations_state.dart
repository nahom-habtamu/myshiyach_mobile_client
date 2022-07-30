import '../../../domain/enitites/conversation.dart';

abstract class GetAllConversationsState {}

class GetAllConversationStateLoaded extends GetAllConversationsState {
  final Stream<List<Conversation>> conversation;
  GetAllConversationStateLoaded(this.conversation);
}

class GetAllConversationStateNoNetwork extends GetAllConversationsState {}

class GetAllConversationStateEmpty extends GetAllConversationsState {
  final Stream value = const Stream.empty();
  GetAllConversationStateEmpty();
}

class GetAllConversationStateError extends GetAllConversationsState {}