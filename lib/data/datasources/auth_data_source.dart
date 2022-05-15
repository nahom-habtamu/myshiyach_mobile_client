import 'package:mnale_client/data/models/register_user_request_model.dart';

import '../models/login/login_request_model.dart';
import '../models/login/login_result_model.dart';

abstract class AuthDataSource {
  Future<LoginResultModel> login(LoginRequestModel loginRequest);
  Future<void> registerUser(RegisterUserRequestModel registerRequest);
}
