import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../core/constants/api_information.dart';
import '../../models/category/main_category_model.dart';

class CategoryRemoteDataSource {
  Future<List<MainCategoryModel>> getAllCategories() async {
    const String endPoint = '$baseUrl/mainCategories';
    final response = await http.get(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var mainCategories = MainCategoryModel.parseCategoriesFromJson(
        json.decode(response.body),
      );
      return mainCategories;
    }
    throw Exception("Couldn't Fetch Main Categories");
  }
}
