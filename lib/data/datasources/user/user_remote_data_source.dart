import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_information.dart';
import '../../models/user/user_model.dart';

class UserRemoteDataSource {
  Future<UserModel> getUserById(String id, String token) async {
    String endPoint = '$baseUrl/users/$id';
    final response = await http.get(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception("User Not Found");
    }
    return UserModel.fromJson(json.decode(response.body));
  }

  Future<UserModel> getUserByUsername(String username) async {
    String endPoint = '$baseUrl/users/username/$username';
    final response = await http.get(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception("User Not Found");
    }
    return UserModel.fromJson(json.decode(response.body));
  }

  Future<UserModel> reportUser(String id, String token) async {
    String endPoint = '$baseUrl/users/report/$id';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception("User Reporting Failed");
    }
    return UserModel.fromJson(json.decode(response.body));
  }

  Future<void> changePassword(String phoneNumber, String password) async {
    String endPoint = '$baseUrl/users/changePassword';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "phoneNumber": phoneNumber,
          "password": password,
        },
      ),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception("Registration Failed");
    }
  }

  Future<UserModel> updateFavoriteProducts(
    String id,
    String token,
    List<String> favoriteProducts,
  ) async {
    String endPoint = '$baseUrl/users/updateFavoriteProducts/$id';
    var body = jsonEncode(
      {"favoriteProducts": favoriteProducts},
    );
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
      body: body,
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception("Error Updating Favorite Products");
    }
    return UserModel.fromJson(json.decode(response.body));
  }
}
