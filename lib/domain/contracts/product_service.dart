import '../../data/models/product/product_model.dart';

abstract class ProductService {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getAllFavoriteProducts();
  Future<void> setFavoriteProducts(List<ProductModel> products);
}
