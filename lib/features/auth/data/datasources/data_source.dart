import '../models/login_request_model.dart';
import '../models/login_result_model.dart';

abstract class DataSource {
  Future<LoginResultModel> login(LoginRequestModel loginRequest);
}
