import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_information.dart';
import '../../models/product/product_model.dart';
import 'product_data_source.dart';

class ProductRemoteDataSource extends ProductDataSource {
  @override
  Future<List<ProductModel>> getAllProducts() async {
    const String endPoint = '$baseUrl/products';
    final response = await http.get(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var products = ProductModel.parseProductsFromJson(
        json.decode(response.body),
      );
      return products;
    }
    throw Exception("Couldn't Fetch Products");
  }
}
