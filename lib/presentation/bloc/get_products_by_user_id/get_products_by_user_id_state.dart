import '../../../domain/enitites/product.dart';

abstract class GetProductsByUserIdState {}

class GetProductsByUserIdEmpty extends GetProductsByUserIdState {}

class GetProductsByUserIdLoading extends GetProductsByUserIdState {}

class GetProductsByUserIdNoNetwork extends GetProductsByUserIdState {}

class GetProductsByUserIdLoaded extends GetProductsByUserIdState {
  final List<Product> products;
  GetProductsByUserIdLoaded(this.products);
}

class GetProductsByUserIdError extends GetProductsByUserIdState {
  final String message;
  GetProductsByUserIdError({required this.message});
}
