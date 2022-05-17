import 'package:firebase_auth/firebase_auth.dart';

import '../contracts/auth.dart';

class VerifyPhoneNumber {
  final Auth repository;

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
