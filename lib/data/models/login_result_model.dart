
import '../../domain/enitites/login_result.dart';

class LoginResultModel extends LoginResult {
  @override
  final String token;

  const LoginResultModel({
    required this.token,
  }) : super(token: token);

  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(token: json["token"]);
  }
}
