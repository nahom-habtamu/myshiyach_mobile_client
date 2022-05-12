import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_information.dart';
import '../models/login_request_model.dart';
import '../models/login_result_model.dart';
import 'data_source.dart';

class AuthRemoteDataSource extends DataSource {
  @override
  Future<LoginResultModel> login(LoginRequestModel loginRequest) async {
    const String endPoint = '$baseUrl/auth';
    final response = await http.post(
      Uri.parse(endPoint),
      body: loginRequest.toJson(),
    );

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return LoginResultModel.fromJson(
        json.decode(response.body),
      );
    }
    throw Exception("User Not Found");
  }
}
