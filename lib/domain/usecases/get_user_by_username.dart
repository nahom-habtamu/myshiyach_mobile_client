import '../contracts/user_service.dart';

import '../../data/models/user/user_model.dart';

class GetUserByUsername {
  final UserService repository;

  GetUserByUsername(this.repository);

  Future<UserModel> call(String username) async {
    return await repository.getUserByUsername(username);
  }
}
