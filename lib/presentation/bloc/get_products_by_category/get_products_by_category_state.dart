import 'package:mnale_client/domain/enitites/product.dart';

abstract class GetProductsByCategoryState {}

class NotTriggered extends GetProductsByCategoryState {}

class Empty extends GetProductsByCategoryState {}

class Loading extends GetProductsByCategoryState {}

class Loaded extends GetProductsByCategoryState {
  final List<Product> products;

  Loaded(this.products);
}

class Error extends GetProductsByCategoryState {
  final String message;
  Error({required this.message});
}
