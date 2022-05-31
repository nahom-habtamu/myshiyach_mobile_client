import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/login/login_request_model.dart';
import '../../data/models/login/login_result_model.dart';
import '../../data/models/register_user/register_user_request_model.dart';

abstract class AuthService {
  Future<LoginResultModel> login(LoginRequestModel loginRequest);
  Future<void> registerUser(RegisterUserRequestModel registerRequest);
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(FirebaseAuthException) onVerificationFailed,
    Function(PhoneAuthCredential) onVerificationComplete,
    Function(String verficationID, int? resendToken) onCodeSent,
  );
  Future<void> authenticatePhoneNumber(PhoneAuthCredential credential);
}
