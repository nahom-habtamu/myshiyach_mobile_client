import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product/product_model.dart';

class ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSource(this.sharedPreferences);

  Future<List<ProductModel>> getFavoriteProducts() async {
    final String? favoriteProducts =
        sharedPreferences.getString("FAVORITE_PRODUCTS");
    if (favoriteProducts != null) {
      var products = ProductModel.parseProductsFromJson(
        json.decode(favoriteProducts),
      );
      return products;
    }
    throw Exception("No Favorite Products");
  }

  Future<void> setFavoriteProducts(List<ProductModel> products) async {
    var productsToEncode = products.map((e) => e.toJson()).toList();
    final String favoriteProducts = json.encode(productsToEncode);
    await sharedPreferences.setString("FAVORITE_PRODUCTS", favoriteProducts);
  }
}
