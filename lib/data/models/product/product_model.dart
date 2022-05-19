import 'dart:convert';

import '../../../domain/enitites/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String title,
    required String description,
    required int price,
    required String mainCategory,
    required String subCategory,
    required String brand,
    // Map<String, dynamic>? other,
  }) : super(
          title: title,
          description: description,
          price: price,
          mainCategory: mainCategory,
          subCategory: subCategory,
          brand: brand,
          // other: other,
        );

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
      title: json["title"],
      description: json["description"],
      price: json["price"],
      mainCategory: json["mainCategory"],
      subCategory: json["subCategory"],
      brand: json["brand"],
      // other: jsonDecode(json["other"]),
    );
  }

  static List<ProductModel> parseProductsFromJson(dynamic jsonList) {
    var products = <ProductModel>[];
    if (jsonList.length > 0) {
      jsonList.forEach((e) => {products.add(ProductModel.fromJson(e))});
    }
    return products;
  }
}
