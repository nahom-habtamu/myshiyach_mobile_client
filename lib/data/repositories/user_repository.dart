import '../../domain/contracts/user_service.dart';
import '../datasources/user/user_remote_data_source.dart';
import '../models/user/user_model.dart';

class UserRepository extends UserService {
  final UserRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  @override
  Future<UserModel> getUserById(String id, String token) {
    return remoteDataSource.getUserById(id, token);
  }
}
