import '../../models/product/add_product_model.dart';
import '../../models/product/edit_product_model.dart';
import '../../models/product/product_model.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> createProduct(
      AddProductModel addProductModel, String token);
  Future<String> deleteProduct(String id, String token);
  Future<ProductModel> updateProduct(
    String id,
    EditProductModel editProductModel,
    String token,
  );
  Future<List<ProductModel>> getProductsByCreatorId(String userId);
  Future<ProductModel> getProductById(String id, String token);
  Future<ProductModel> refreshProduct(String id, String token);
}
