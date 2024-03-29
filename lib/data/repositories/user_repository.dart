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
  Future<UserModel> reportUser(String id, String token) {
    return remoteDataSource.reportUser(id, token);
  }

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
    return remoteDataSource.changePassword(phoneNumber, password);
  }

  @override
  Future<bool> getIsAppOpenedFirstTime() {
    return localDataSource.getIsAppOpenedFirstTime();
  }

  @override
  Future<void> storeIsAppOpenedFirstTime() {
    return localDataSource.setIsAppOpenedFirstTime();
  }

  @override
  Future<UserModel> getUserByUsername(String username) {
    return remoteDataSource.getUserByUsername(username);
  }

  @override
  Future<UserModel> updateFavoriteProducts(
      String id, String token, List<String> favoriteProducts) {
    return remoteDataSource.updateFavoriteProducts(id, token, favoriteProducts);
  }
}
