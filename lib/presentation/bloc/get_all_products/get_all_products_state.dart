import '../../../domain/enitites/get_paginate_products_result.dart';

abstract class GetAllProductsState {}

class NotTriggered extends GetAllProductsState {}

class Empty extends GetAllProductsState {}

class Loading extends GetAllProductsState {}

class Loaded extends GetAllProductsState {
  final GetPaginatedProductsResult result;
  Loaded(this.result);
}

class Error extends GetAllProductsState {
  final String message;
  Error({required this.message});
}
