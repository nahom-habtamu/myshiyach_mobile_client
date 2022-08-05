import 'package:mnale_client/domain/enitites/get_paginate_products_result.dart';

import '../../../domain/enitites/main_category.dart';
import '../../../domain/enitites/product.dart';

abstract class DisplayAllProductsState {}

class Empty extends DisplayAllProductsState {}

class Loading extends DisplayAllProductsState {}

class NoNetwork extends DisplayAllProductsState {}

class Loaded extends DisplayAllProductsState {
  final GetPaginatedProductsResult paginatedResult;
  final List<MainCategory> categories;
  final List<Product> favorites;
  Loaded(this.paginatedResult, this.categories, this.favorites);
}

class Error extends DisplayAllProductsState {
  final String message;
  Error({required this.message});
}
