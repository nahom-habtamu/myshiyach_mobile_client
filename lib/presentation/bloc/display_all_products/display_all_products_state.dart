import 'package:mnale_client/domain/enitites/main_category.dart';
import 'package:mnale_client/domain/enitites/product.dart';

abstract class DisplayAllProductsState {}

class Empty extends DisplayAllProductsState {}

class Loading extends DisplayAllProductsState {}

class Loaded extends DisplayAllProductsState {
  final List<Product> products;
  final List<MainCategory> categories;
  final List<Product> favorites;
  Loaded(this.products, this.categories, this.favorites);
}

class Error extends DisplayAllProductsState {
  final String message;
  Error({required this.message});
}
