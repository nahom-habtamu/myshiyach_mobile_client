import '../../screen_arguments/chat_detail_page_arguments.dart';

abstract class HandleGoingToMessageState {}

class AddConversationEmpty extends HandleGoingToMessageState {}

class AddConversationLoading extends HandleGoingToMessageState {}

class AddConversationSuccessfull extends HandleGoingToMessageState {
  final ChatDetailPageArguments chatDetailPageArguments;
  AddConversationSuccessfull(this.chatDetailPageArguments);
}

class AddConversationError extends HandleGoingToMessageState {
  final String message;
  AddConversationError({required this.message});
}
