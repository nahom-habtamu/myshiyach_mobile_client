abstract class RegisterUserState {}

class Empty extends RegisterUserState {}

class Loading extends RegisterUserState {}

class Successfull extends RegisterUserState {}

class Error extends RegisterUserState {
  final String message;
  Error({required this.message});
}