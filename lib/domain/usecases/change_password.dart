import '../contracts/user_service.dart';

class ChangePassword {
  final UserService repository;

  ChangePassword(this.repository);

  Future<void> call(String phoneNumber, String password) {
    return repository.changePassword(phoneNumber, password);
  }
}
