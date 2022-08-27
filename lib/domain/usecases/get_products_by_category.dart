import '../../core/utils/date_time_formatter.dart';
import '../contracts/product_service.dart';
import '../enitites/product.dart';

class GetProductsByCategory {
  final ProductService repository;

  GetProductsByCategory(this.repository);

  Future<List<Product>> call(String mainCategory, String subCategory) async {
    var parsedResult = await repository.getAllProducts();
    parsedResult.sort(((a, b) => _compareRefreshedAt(a, b)));
    return parsedResult
        .where((element) =>
            element.mainCategory == mainCategory &&
            element.subCategory == subCategory)
        .toList();
  }

  int _compareRefreshedAt(Product a, Product b) {
    var firstDate = DateFormatterUtil.parseProductCreatedDate(a.refreshedAt);
    var secondDate = DateFormatterUtil.parseProductCreatedDate(b.refreshedAt);
    return secondDate.compareTo(firstDate);
  }
}
