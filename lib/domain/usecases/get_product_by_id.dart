import '../../data/models/product/product_model.dart';
import '../contracts/product_service.dart';

class GetProductById {
  final ProductService repository;

  GetProductById(this.repository);

  Future<ProductModel> call(String id, String token) {
    return repository.getProductById(id, token);
  }
}
