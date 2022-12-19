import '../../../domain/enitites/user.dart';

abstract class ReportUserState {}

class ReportUserEmpty extends ReportUserState {}

class ReportUserLoading extends ReportUserState {}

class ReportUserNoNetwork extends ReportUserState {}

class ReportUserSuccessfull extends ReportUserState {
  final User user;
  ReportUserSuccessfull(this.user);
}

class ReportUserError extends ReportUserState {
  final String message;
  ReportUserError({required this.message});
}
