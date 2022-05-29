import '../enitites/product.dart';
import '../contracts/product_service.dart';
import '../../data/models/product/add_product_model.dart';

class CreateProduct {
  final ProductService repository;

  CreateProduct(this.repository);

  Future<Product> call(AddProductModel addProductModel) async {
    var result = await repository.createProduct(addProductModel);
    return result;
  }
}
