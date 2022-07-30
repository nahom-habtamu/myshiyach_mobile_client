import '../../../domain/enitites/login_result.dart';
import '../../../domain/enitites/user.dart';

abstract class AuthState {}

class AuthNotTriggered extends AuthState {}

class AuthLoading extends AuthState {}

class AuthNoNetwork extends AuthState {}

class AuthSuccessfull extends AuthState {
  final LoginResult loginResult;
  final User currentUser;
  AuthSuccessfull(this.loginResult, this.currentUser);
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
