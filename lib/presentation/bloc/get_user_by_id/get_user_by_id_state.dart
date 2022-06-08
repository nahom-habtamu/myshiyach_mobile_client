import '../../../domain/enitites/user.dart';

abstract class GetUserByIdState {}

class GetUserByIdEmpty extends GetUserByIdState {}

class GetUserByIdLoading extends GetUserByIdState {}

class GetUserByIdLoaded extends GetUserByIdState {
  final User user;
  GetUserByIdLoaded(this.user);
}

class GetUserByIdError extends GetUserByIdState {
  final String message;
  GetUserByIdError({required this.message});
}
