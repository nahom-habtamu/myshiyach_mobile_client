import '../../../domain/enitites/get_paginate_products_result.dart';

abstract class GetPaginatedProductsState {}

class NotTriggered extends GetPaginatedProductsState {}

class Empty extends GetPaginatedProductsState {}

class Loading extends GetPaginatedProductsState {}

class Loaded extends GetPaginatedProductsState {
  final GetPaginatedProductsResult result;
  Loaded(this.result);
}

class Error extends GetPaginatedProductsState {
  final String message;
  Error({required this.message});
}
