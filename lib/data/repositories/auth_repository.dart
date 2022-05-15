import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/services/network_info.dart';
import '../../domain/contracts/auth.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login/login_result_model.dart';
import '../models/login/login_request_model.dart';
import '../models/register_user_request_model.dart';

class AuthRepository extends Auth {
  final AuthRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  AuthRepository({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<LoginResultModel> login(LoginRequestModel loginRequest) async {
    var connectionAvailable = await networkInfo.isConnected();
    if (connectionAvailable) {
      return dataSource.login(loginRequest);
    }
    throw ServerException();
  }

  @override
  Future<void> regusterUser(RegisterUserRequestModel registerRequest) async {
    var connectionAvailable = await networkInfo.isConnected();
    if (connectionAvailable) {
      return dataSource.registerUser(registerRequest);
    }
    throw ServerException();
  }
}
