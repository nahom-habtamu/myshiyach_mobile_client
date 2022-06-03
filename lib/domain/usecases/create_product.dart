import '../enitites/product.dart';
import '../contracts/product_service.dart';
import '../../data/models/product/add_product_model.dart';

class CreateProduct {
  final ProductService repository;

  CreateProduct(this.repository);

  Future<Product> call(AddProductModel addProductModel, String token) async {
    var result = await repository.createProduct(addProductModel, token);
    return result;
  }
}
