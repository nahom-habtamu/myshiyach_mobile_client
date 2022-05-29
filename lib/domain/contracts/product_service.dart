import 'package:mnale_client/data/models/product/add_product_model.dart';

import '../../data/models/product/product_model.dart';

abstract class ProductService {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getAllFavoriteProducts();
  Future<void> setFavoriteProducts(List<ProductModel> products);
  Future<ProductModel> createProduct(AddProductModel addProductModel);
}
