import '../../../domain/enitites/user.dart';

abstract class GetUserByIdState {}

class Empty extends GetUserByIdState {}

class Loading extends GetUserByIdState {}

class Loaded extends GetUserByIdState {
  final User user;
  Loaded(this.user);
}

class Error extends GetUserByIdState {
  final String message;
  Error({required this.message});
}
