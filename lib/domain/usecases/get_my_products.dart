import '../contracts/product_service.dart';
import '../enitites/product.dart';

class GetMyProducts {
  final ProductService repository;

  GetMyProducts(this.repository);

  Future<List<Product>> call(String userId) async {
    var parsedResult = await repository.getProductsByCreatorId(userId);
    return parsedResult;
  }
}
