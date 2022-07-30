abstract class RegisterUserState {}

class RegisterUserEmpty extends RegisterUserState {}

class RegisterUserLoading extends RegisterUserState {}

class RegisterUserNoNetwork extends RegisterUserState {}

class RegisterUserSuccessfull extends RegisterUserState {}

class RegisterUserError extends RegisterUserState {
  final String message;
  RegisterUserError({required this.message});
}
