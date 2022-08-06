import 'page_and_limit.dart';
import 'product.dart';

class GetPaginatedProductsResult {
  final PageAndLimit? prev;
  final PageAndLimit? next;
  final List<Product> products;

  GetPaginatedProductsResult({
    this.prev,
    this.next,
    required this.products,
  });
}
