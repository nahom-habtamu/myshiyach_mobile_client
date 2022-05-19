import '../contracts/product_service.dart';
import '../enitites/product.dart';

class GetAllProducts {
  final ProductService repository;

  GetAllProducts(this.repository);

  Future<List<Product>> call() async {
    var parsedResult = await repository.getAllProducts();
    return parsedResult;
  }
}
