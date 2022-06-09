abstract class LogOutState {}

class LogOutNotTriggered extends LogOutState {}

class LogOutLoading extends LogOutState {}

class LogOutSuccessfull extends LogOutState {
  LogOutSuccessfull();
}

class LogOutError extends LogOutState {
  final String message;
  LogOutError({required this.message});
}
