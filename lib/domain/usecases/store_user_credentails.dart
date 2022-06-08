import '../../data/models/login/login_request_model.dart';
import '../contracts/user_service.dart';

class StoreUserCredentials {
  final UserService repository;

  StoreUserCredentials(this.repository);

  Future<void> call(LoginRequestModel loginRequestModel) {
    return repository.storeUserCredentials(loginRequestModel);
  }
}
