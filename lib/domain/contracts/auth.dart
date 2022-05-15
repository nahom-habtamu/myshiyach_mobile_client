import 'package:mnale_client/data/models/register_user_request_model.dart';

import '../../data/models/login/login_request_model.dart';
import '../../data/models/login/login_result_model.dart';

abstract class Auth {
  Future<LoginResultModel> login(LoginRequestModel loginRequest);
  Future<void> regusterUser(RegisterUserRequestModel registerRequest);
}
