import '../../screen_arguments/chat_detail_page_arguments.dart';

abstract class HandleGoingToMessageState {}

class HandleGoingToMessageEmpty extends HandleGoingToMessageState {}

class HandleGoingToMessageLoading extends HandleGoingToMessageState {}

class HandleGoingToMessageSuccessfull extends HandleGoingToMessageState {
  final ChatDetailPageArguments chatDetailPageArguments;
  HandleGoingToMessageSuccessfull(this.chatDetailPageArguments);
}

class HandleGoingToMessageError extends HandleGoingToMessageState {
  final String message;
  HandleGoingToMessageError({required this.message});
}
