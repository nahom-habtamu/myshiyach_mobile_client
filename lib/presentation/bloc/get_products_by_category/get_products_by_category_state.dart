import 'package:mnale_client/domain/enitites/product.dart';

abstract class GetProductsByCategoryState {}

class NotTriggered extends GetProductsByCategoryState {}

class Empty extends GetProductsByCategoryState {}

class Loading extends GetProductsByCategoryState {}

class Loaded extends GetProductsByCategoryState {
  final List<Product> products;
  final List<Product> favorites;

  Loaded(this.products,this.favorites);
}

class Error extends GetProductsByCategoryState {
  final String message;
  Error({required this.message});
}
