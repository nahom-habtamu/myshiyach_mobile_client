import 'package:firebase_auth/firebase_auth.dart';

import '../contracts/auth_service.dart';

class VerifyPhoneNumber {
  final AuthService repository;

  const VerifyPhoneNumber(this.repository);

  Future<void> call(
    String phoneNumber,
    Function(FirebaseAuthException) onVerificationFailed,
    Function(PhoneAuthCredential) onVerificationComplete,
    Function(String verficationID, int? resendToken) onCodeSent,
  ) {
    return repository.verifyPhoneNumber(
      phoneNumber,
      onVerificationFailed,
      onVerificationComplete,
      onCodeSent,
    );
  }
}
