import '../contracts/product_service.dart';

class GenerateShareLinkForProduct {
  final ProductService repository;

  GenerateShareLinkForProduct(this.repository);

  Future<String?> call(String id) {
    return repository.generateShareLink(id);
  }
}
