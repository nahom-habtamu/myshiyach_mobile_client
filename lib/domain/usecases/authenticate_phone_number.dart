import 'package:firebase_auth/firebase_auth.dart';

import '../contracts/auth.dart';

class AuthenticatePhoneNumber {
  final Auth repository;

  const AuthenticatePhoneNumber(this.repository);

  Future<void> call(PhoneAuthCredential credential) {
    return repository.authenticatePhoneNumber(credential);
  }
}
