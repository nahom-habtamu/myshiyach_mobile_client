import '../../../domain/enitites/product.dart';

abstract class RefreshProductState {}

class RefreshPostEmpty extends RefreshProductState {}

class RefreshPostLoading extends RefreshProductState {}

class RefreshPostNoNetwork extends RefreshProductState {}

class RefreshPostSuccessfull extends RefreshProductState {
  final Product product;
  RefreshPostSuccessfull(this.product);
}

class RefreshPostError extends RefreshProductState {
  final String message;
  RefreshPostError({required this.message});
}
