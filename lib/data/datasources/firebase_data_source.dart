import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseDataSource {
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(FirebaseAuthException) onVerificationFailed,
    Function(PhoneAuthCredential) onVerificationComplete,
    Function(String verficationID, int? resendToken) onCodeSent,
  );

  Future<void> authenticatePhoneNumber(PhoneAuthCredential credential);
}

class FirebaseDataSouceImpl extends FirebaseDataSource {
  @override
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(FirebaseAuthException) onVerificationFailed,
    Function(PhoneAuthCredential) onVerificationComplete,
    Function(String verficationID, int? resendToken) onCodeSent,
  ) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationComplete,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (String verificationID) {},
      timeout: const Duration(seconds: 120),
    );
  }

  @override
  Future<void> authenticatePhoneNumber(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
