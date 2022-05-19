import 'package:firebase_auth/firebase_auth.dart';

import '../contracts/auth_service.dart';

class AuthenticatePhoneNumber {
  final AuthService repository;

  const AuthenticatePhoneNumber(this.repository);

  Future<void> call(PhoneAuthCredential credential) {
    return repository.authenticatePhoneNumber(credential);
  }
}
