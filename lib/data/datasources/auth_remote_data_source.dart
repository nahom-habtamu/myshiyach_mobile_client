import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_information.dart';
import '../models/login/login_request_model.dart';
import '../models/login/login_result_model.dart';
import '../models/register_user/register_user_request_model.dart';
import 'auth_data_source.dart';

class AuthRemoteDataSource extends AuthDataSource {
  @override
  Future<LoginResultModel> login(LoginRequestModel loginRequest) async {
    const String endPoint = '$baseUrl/auth';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(loginRequest.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return LoginResultModel.fromJson(
        json.decode(response.body),
      );
    }
    throw Exception("User Not Found");
  }

  @override
  Future<void> registerUser(RegisterUserRequestModel registerRequest) async {
    const String endPoint = '$baseUrl/auth';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(registerRequest.toJson()),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception("User Not Found");
    }
  }
}
