import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_information.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../models/filter/filter_criteria_model.dart';
import '../../models/product/add_product_model.dart';
import '../../models/product/edit_product_model.dart';
import '../../models/product/get_paginated_products_result_model.dart';
import '../../models/product/page_and_limit_model.dart';
import '../../models/product/product_model.dart';
import 'product_data_source.dart';

class ProductRemoteDataSource extends ProductDataSource {
  @override
  Future<GetPaginatedProductsResultModel> getPaginatedProducts(
    PageAndLimitModel pageAndLimit,
    FilterCriteriaModel? filterCriteriaModel,
  ) async {
    String endPoint = '$baseUrl/products/getPaginated';

    var requestBody = {
      "page": pageAndLimit.page,
      "limit": pageAndLimit.limit,
      "filterCriteria": filterCriteriaModel?.toJson()
    };

    final response = await http.post(
      Uri.parse(endPoint),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      var result = GetPaginatedProductsResultModel.fromJson(
        json.decode(response.body),
      );
      return result;
    }
    throw Exception("Couldn't Fetch Products");
  }

  @override
  Future<ProductModel> createProduct(
      AddProductModel addProductModel, String token) async {
    const String endPoint = '$baseUrl/products';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
      body: jsonEncode(addProductModel.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var product = ProductModel.fromJson(
        json.decode(response.body),
      );
      return product;
    }
    throw Exception("Couldn't Add Product");
  }

  @override
  Future<String> deleteProduct(String id, String token) async {
    String endPoint = '$baseUrl/products/$id';
    final response = await http.delete(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = json.decode(response.body);
      return data["productId"] as String;
    }
    throw Exception("Couldn't Add Product");
  }

  @override
  Future<ProductModel> updateProduct(
    String id,
    EditProductModel editProductModel,
    String token,
  ) async {
    String endPoint = '$baseUrl/products/$id';

    var body = jsonEncode(editProductModel.toJson());

    final response = await http.patch(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = json.decode(response.body);
      return ProductModel.fromJson(data);
    }
    throw Exception("Couldn't Update Product");
  }

  @override
  Future<List<ProductModel>> getProductsByCreatorId(String userId) async {
    final String endPoint = '$baseUrl/products/createdBy/$userId';
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
      products.sort(((a, b) => _compareRefreshedAt(a, b)));
      return products;
    }
    throw Exception("Couldn't Fetch Products By User");
  }

  int _compareRefreshedAt(ProductModel a, ProductModel b) {
    var firstDate = DateFormatterUtil.parseProductCreatedDate(a.refreshedAt);
    var secondDate = DateFormatterUtil.parseProductCreatedDate(b.refreshedAt);
    return secondDate.compareTo(firstDate);
  }

  @override
  Future<ProductModel> getProductById(String id, String token) async {
    final String endPoint = '$baseUrl/products/$id';
    final response = await http.get(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    if (response.statusCode == 200) {
      var product = ProductModel.fromJson(
        json.decode(response.body),
      );
      return product;
    }
    throw Exception("Couldn't Fetch Product");
  }

  @override
  Future<ProductModel> refreshProduct(String id, String token) async {
    final String endPoint = '$baseUrl/products/refresh/$id';
    final response = await http.patch(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var product = ProductModel.fromJson(
        json.decode(response.body),
      );
      return product;
    }
    throw Exception("Couldn't Refresh Product");
  }

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
  Future<ProductModel> reportProduct(String id, String token) async {
    final String endPoint = '$baseUrl/products/report/$id';
    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var product = ProductModel.fromJson(
        json.decode(response.body),
      );
      return product;
    }
    throw Exception("Couldn't Report Product");
  }

  @override
  Future<List<ProductModel>> getProductsByListOfId(
      List<String> ids, String token) async {
    String endPoint = '$baseUrl/products/getAllProductsWithListOfId';

    var body = jsonEncode({"listOfId": ids});

    final response = await http.post(
      Uri.parse(endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = json.decode(response.body);
      return ProductModel.parseProductsFromJson(data);
    }
    throw Exception("Couldn't Fetch Products By These Id");
  }
}
