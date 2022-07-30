abstract class VerifyPhoneNumberState {}

class Empty extends VerifyPhoneNumberState {}

class Loading extends VerifyPhoneNumberState {}

class NoNetwork extends VerifyPhoneNumberState {}

class CodeSent extends VerifyPhoneNumberState {
  final String verificationId;
  CodeSent(this.verificationId);
}

class Error extends VerifyPhoneNumberState {
  final String message;
  Error({required this.message});
}
