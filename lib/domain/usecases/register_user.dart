import '../contracts/auth.dart';
import '../../data/models/register_user/register_user_request_model.dart';

class RegisterUser {
  final Auth repository;

  const RegisterUser(this.repository);

  Future<void> call(RegisterUserRequestModel request) async {
    await repository.registerUser(request);
  }
}
