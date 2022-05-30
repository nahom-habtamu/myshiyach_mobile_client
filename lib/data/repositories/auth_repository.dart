import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/services/network_info.dart';
import '../../domain/contracts/auth_service.dart';
import '../datasources/auth/auth_remote_data_source.dart';
import '../datasources/firebase/firebase_auth_data_source.dart';
import '../models/login/login_request_model.dart';
import '../models/login/login_result_model.dart';
import '../models/register_user/register_user_request_model.dart';
import '../models/user/user_model.dart';

class AuthRepository extends AuthService {
  final FirebaseAuthDataSource firebaseDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepository({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.firebaseDataSource,
  });

  @override
  Future<LoginResultModel> login(LoginRequestModel loginRequest) async {
    var connectionAvailable = await networkInfo.isConnected();
    if (connectionAvailable) {
      return remoteDataSource.login(loginRequest);
    }
    throw ServerException();
  }

  @override
  Future<void> registerUser(RegisterUserRequestModel registerRequest) async {
    var connectionAvailable = await networkInfo.isConnected();
    if (connectionAvailable) {
      return remoteDataSource.registerUser(registerRequest);
    }
    throw ServerException();
  }

  @override
  Future<void> verifyPhoneNumber(
      String phoneNumber,
      Function(FirebaseAuthException) onVerificationFailed,
      Function(PhoneAuthCredential) onVerificationComplete,
      Function(String, int?) onCodeSent) {
    return firebaseDataSource.verifyPhoneNumber(
      phoneNumber,
      onVerificationFailed,
      onVerificationComplete,
      onCodeSent,
    );
  }

  @override
  Future<void> authenticatePhoneNumber(PhoneAuthCredential credential) {
    return firebaseDataSource.authenticatePhoneNumber(credential);
  }

  @override
  Future<UserModel> getCurrentUser(String token) {
    return remoteDataSource.getCurrentUser(token);
  }
}
