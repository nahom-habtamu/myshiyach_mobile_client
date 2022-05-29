import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_information.dart';
import '../../models/product/product_model.dart';
import '../../models/product/add_product_model.dart';
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

  @override
  Future<ProductModel> createProduct(AddProductModel addProductModel) async {
    const String endPoint = '$baseUrl/products';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(addProductModel.toJson())
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var product = ProductModel.fromJson(
        json.decode(response.body),
      );
      return product;
    }
    throw Exception("Couldn't Add Product");
  }
}
