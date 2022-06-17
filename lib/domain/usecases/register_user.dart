import '../contracts/auth_service.dart';
import '../../data/models/register_user/register_user_request_model.dart';

class RegisterUser {
  final AuthService repository;

  const RegisterUser(this.repository);

  Future<void> call(RegisterUserRequestModel request) async {
    return await repository.registerUser(request);
  }
}
