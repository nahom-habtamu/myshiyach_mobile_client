import '../../data/models/login/login_request_model.dart';
import '../contracts/auth_service.dart';
import '../enitites/login_result.dart';

class Login {
  final AuthService repository;

  const Login(this.repository);

  Future<LoginResult> call(LoginRequestModel request) async {
    var parsedResult = await repository.login(request);
    return parsedResult;
  }
}
