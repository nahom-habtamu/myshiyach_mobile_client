import '../contracts/product_service.dart';
import '../enitites/product.dart';

class GetProductsByCategory {
  final ProductService repository;

  GetProductsByCategory(this.repository);

  Future<List<Product>> call(String mainCategory, String subCategory) async {
    var parsedResult = await repository.getAllProducts();
    return parsedResult
        .where((element) =>
            element.mainCategory == mainCategory &&
            element.subCategory == subCategory)
        .toList();
  }
}
