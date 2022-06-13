abstract class AuthPhoneNumberState {}

class AuthPhoneNumberEmpty extends AuthPhoneNumberState {}

class AuthPhoneNumberLoading extends AuthPhoneNumberState {}

class AuthPhoneNumberSuccessfull extends AuthPhoneNumberState {}

class AuthPhoneNumberError extends AuthPhoneNumberState {
  final String message;
  AuthPhoneNumberError({required this.message});
}
