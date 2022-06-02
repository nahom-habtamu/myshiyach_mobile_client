import '../contracts/product_service.dart';

class DeleteProductById {
  final ProductService repository;

  DeleteProductById(this.repository);

  Future<String> call(String id, String token) async {
    var parsedResult = await repository.deleteProduct(id, token);
    return parsedResult;
  }
}
