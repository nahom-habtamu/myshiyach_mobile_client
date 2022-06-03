import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_information.dart';
import 'city_data_source.dart';

class CityRemoteDataSource extends CityDataSource {
  @override
  Future<List<String>> getAllCities() async {
    const String endPoint = '$baseUrl/cities';
    final response = await http.get(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var cities = List<String>.from(json.decode(response.body));
      return cities;
    }
    throw Exception("Couldn't Fetch Cities");
  }
}
