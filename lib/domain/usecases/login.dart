import '../../data/models/login/login_request_model.dart';
import '../contracts/auth.dart';
import '../enitites/login_result.dart';

class Login {
  final Auth repository;

  const Login(this.repository);

  Future<LoginResult> call(LoginRequestModel request) async {
    var parsedResult = await repository.login(request);
    return parsedResult;
  }
}
