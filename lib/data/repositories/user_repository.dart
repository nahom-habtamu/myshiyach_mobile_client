import '../../domain/contracts/user_service.dart';
import '../datasources/user/user_local_data_source.dart';
import '../datasources/user/user_remote_data_source.dart';
import '../models/login/login_request_model.dart';
import '../models/user/user_model.dart';

class UserRepository extends UserService {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserModel> getUserById(String id, String token) {
    return remoteDataSource.getUserById(id, token);
  }

  @override
  Future<LoginRequestModel?> getStoredUserCredential() {
    return localDataSource.getStoredUserCredential();
  }

  @override
  Future<void> storeUserCredentials(LoginRequestModel loginRequestModel) {
    return localDataSource.storeUserCredentials(loginRequestModel);
  }

  @override
  Future<void> changePassword(String phoneNumber, String password) {
    return remoteDataSource.changePassword("+251926849888", password);
  }
}
