import '../../../domain/enitites/login_result.dart';

class LoginResultModel extends LoginResult {
  LoginResultModel({required String token}) : super(token: token);

  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(token: json["token"]);
  }
}
