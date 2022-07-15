import '../../data/models/product/add_product_model.dart';
import '../../data/models/product/edit_product_model.dart';
import '../../data/models/product/product_model.dart';

abstract class ProductService {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id, String token);
  Future<List<ProductModel>> getAllFavoriteProducts();
  Future<void> setFavoriteProducts(List<ProductModel> products);
  Future<ProductModel> createProduct(
      AddProductModel addProductModel, String token);
  Future<List<String>> uploadProductPictures(List<dynamic> images);
  Future<String> deleteProduct(String id, String token);
  Future<ProductModel> updateProduct(
    String id,
    EditProductModel editProductModel,
    String token,
  );
  Future<List<ProductModel>> getProductsByCreatorId(String userId);
  Future<ProductModel> refreshProduct(String id, String token);
}
