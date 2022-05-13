import '../../domain/enitites/login_result.dart';

abstract class AuthState {}

class Empty extends AuthState {}

class Loading extends AuthState {}

class Loaded extends AuthState {
  final LoginResult loginResult;
  Loaded(this.loginResult);
}

class Error extends AuthState {
  final String message;
  Error({required this.message});
}