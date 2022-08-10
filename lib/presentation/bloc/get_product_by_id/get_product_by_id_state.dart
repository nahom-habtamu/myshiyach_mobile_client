import 'package:mnale_client/domain/enitites/product.dart';

abstract class GetProductByIdState {}

class GetProductByIdEmpty extends GetProductByIdState {}

class GetProductByIdLoading extends GetProductByIdState {}

class GetProductByIdLoaded extends GetProductByIdState {
  final Product product;
  GetProductByIdLoaded(this.product);
}

class GetProductByIdError extends GetProductByIdState {
  final String message;
  GetProductByIdError({required this.message});
}
