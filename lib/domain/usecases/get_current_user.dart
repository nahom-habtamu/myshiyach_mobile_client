import 'package:mnale_client/data/models/user/user_model.dart';
import 'package:mnale_client/domain/contracts/auth_service.dart';

class GetCurrentUser {
  final AuthService repository;

  GetCurrentUser(this.repository);

  Future<UserModel> call(String token) async {
    return await repository.getCurrentUser(token);
  }
}
