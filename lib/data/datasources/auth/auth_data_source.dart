import '../../models/login/login_request_model.dart';
import '../../models/login/login_result_model.dart';
import '../../models/register_user/register_user_request_model.dart';

abstract class AuthDataSource {
  Future<LoginResultModel> login(LoginRequestModel loginRequest);
  Future<void> registerUser(RegisterUserRequestModel registerRequest);
}
