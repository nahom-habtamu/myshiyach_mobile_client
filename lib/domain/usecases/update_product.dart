import '../../data/models/product/edit_product_model.dart';
import '../contracts/product_service.dart';
import '../enitites/product.dart';

class UpdateProduct {
  final ProductService repository;

  UpdateProduct(this.repository);

  Future<Product> call(
    String id,
    EditProductModel editProductModel,
    String token,
  ) async {
    return await repository.updateProduct(id, editProductModel, token);
  }
}
