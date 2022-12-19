import '../../data/models/user/user_model.dart';
import '../contracts/user_service.dart';

class ReportUser {
  final UserService repository;

  const ReportUser(this.repository);

  Future<UserModel> call(String id, String token) async {
    return await repository.reportUser(id, token);
  }
}
