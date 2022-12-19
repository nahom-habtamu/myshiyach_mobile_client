import '../../data/models/product/product_model.dart';
import '../contracts/product_service.dart';

class ReportProduct {
  final ProductService repository;

  const ReportProduct(this.repository);

  Future<ProductModel> call(String id, String token) async {
    return await repository.reportProduct(id, token);
  }
}
