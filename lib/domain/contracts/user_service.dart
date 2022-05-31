import '../../data/models/user/user_model.dart';

abstract class UserService {
  Future<UserModel> getUserById(String id, String token);
}
