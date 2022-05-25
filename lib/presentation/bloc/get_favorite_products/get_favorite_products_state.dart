import '../../../domain/enitites/product.dart';

abstract class GetFavoriteProductsState {}

class Empty extends GetFavoriteProductsState {}

class Loading extends GetFavoriteProductsState {}

class Loaded extends GetFavoriteProductsState {
  final List<Product> products;
  Loaded(this.products);
}

class Error extends GetFavoriteProductsState {
  final String message;
  Error({required this.message});
}
