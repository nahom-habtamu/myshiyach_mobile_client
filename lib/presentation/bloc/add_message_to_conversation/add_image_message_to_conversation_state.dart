abstract class AddImageMessageToConversationState {}

class AddImageMessageToConversationNotTriggered
    extends AddImageMessageToConversationState {}

class AddImageMessageToConversationLoading
    extends AddImageMessageToConversationState {}

class AddImageMessageToConversationSuccessfull
    extends AddImageMessageToConversationState {}

class AddImageMessageToConversationError
    extends AddImageMessageToConversationState {
  final String message;
  AddImageMessageToConversationError({required this.message});
}
