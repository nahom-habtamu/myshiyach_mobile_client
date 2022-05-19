import 'package:mnale_client/domain/enitites/product.dart';

abstract class GetAllProductsState {}

class Empty extends GetAllProductsState {}

class Loading extends GetAllProductsState {}

class Loaded extends GetAllProductsState {
  final List<Product> products;
  Loaded(this.products);
}

class Error extends GetAllProductsState {
  final String message;
  Error({required this.message});
}
