import '../contracts/product_service.dart';
import '../enitites/product.dart';

class GetFavoriteProducts {
  final ProductService repository;

  GetFavoriteProducts(this.repository);

  Future<List<Product>> call() async {
    var parsedResult = await repository.getAllFavoriteProducts();
    return parsedResult;
  }
}
