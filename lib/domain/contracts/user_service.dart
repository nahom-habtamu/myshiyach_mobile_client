import 'package:mnale_client/data/models/login/login_request_model.dart';

import '../../data/models/user/user_model.dart';

abstract class UserService {
  Future<UserModel> getUserById(String id, String token);
  Future<LoginRequestModel?> getStoredUserCredential();
  Future<void> storeUserCredentials(LoginRequestModel loginRequestModel);
}
