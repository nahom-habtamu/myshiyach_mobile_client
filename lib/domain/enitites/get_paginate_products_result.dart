import '../../data/models/product/product_model.dart';
import 'page_and_limit.dart';

class GetPaginatedProductsResult {
  final PageAndLimit? prev;
  final PageAndLimit? next;
  final List<ProductModel> products;

  GetPaginatedProductsResult({
    this.prev,
    this.next,
    required this.products,
  });
}
