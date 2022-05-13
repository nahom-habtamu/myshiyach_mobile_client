import '../../data/models/login_request_model.dart';
import '../../data/models/login_result_model.dart';

abstract class Auth {
  Future<LoginResultModel> login(LoginRequestModel loginRequest);
}
