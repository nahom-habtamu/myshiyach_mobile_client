import '../../data/models/product/product_model.dart';

abstract class ProductService {
  Future<List<ProductModel>> getAllProducts();
}
