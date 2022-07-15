import '../../data/models/product/product_model.dart';
import '../contracts/product_service.dart';

class RefreshProduct {
  final ProductService repository;

  const RefreshProduct(this.repository);

  Future<ProductModel> call(String id, String token) async {
    return await repository.refreshProduct(id, token);
  }
}
