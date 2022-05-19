import 'package:mnale_client/data/models/product/product_model.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getAllProducts();
}
