import '../../data/models/login/login_request_model.dart';
import '../../data/models/user/user_model.dart';

abstract class UserService {
  Future<UserModel> getUserById(String id, String token);
  Future<UserModel> getUserByUsername(String username);
  Future<UserModel> reportUser(String id, String token);
  Future<void> changePassword(String phoneNumber, String password);
  Future<LoginRequestModel?> getStoredUserCredential();
  Future<void> storeUserCredentials(LoginRequestModel loginRequestModel);
  Future<void> storeIsAppOpenedFirstTime();
  Future<bool> getIsAppOpenedFirstTime();
}
