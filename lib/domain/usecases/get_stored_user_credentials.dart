import '../../data/models/login/login_request_model.dart';
import '../contracts/user_service.dart';

class GetStoredUserCredentials {
  final UserService repository;

  GetStoredUserCredentials(this.repository);

  Future<LoginRequestModel?> call() {
    return repository.getStoredUserCredential();
  }
}
