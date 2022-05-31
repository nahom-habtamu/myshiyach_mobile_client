import '../contracts/user_service.dart';

import '../../data/models/user/user_model.dart';

class GetUserById {
  final UserService repository;

  GetUserById(this.repository);

  Future<UserModel> call(String id, String token) async {
    return await repository.getUserById(id, token);
  }
}
