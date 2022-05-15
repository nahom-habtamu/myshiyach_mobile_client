abstract class RegisterUserState {}

class Empty extends RegisterUserState {}

class Loading extends RegisterUserState {}

class Loaded extends RegisterUserState {}

class Error extends RegisterUserState {
  final String message;
  Error({required this.message});
}