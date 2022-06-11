import '../../../domain/enitites/product.dart';

abstract class GetMyProductsState {}

class GetMyProductsEmpty extends GetMyProductsState {}

class GetMyProductsLoading extends GetMyProductsState {}

class GetMyProductsLoaded extends GetMyProductsState {
  final List<Product> products;
  GetMyProductsLoaded(this.products);
}

class GetMyProductsError extends GetMyProductsState {
  final String message;
  GetMyProductsError({required this.message});
}
