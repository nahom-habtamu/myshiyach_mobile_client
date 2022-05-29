import '../../../domain/enitites/product.dart';

abstract class CreateProductState {}

class AddPostNotTriggered extends CreateProductState {}

class AddPostLoading extends CreateProductState {}

class AddPostSuccessfull extends CreateProductState {
  final Product product;
  AddPostSuccessfull(this.product);
}

class AddPostError extends CreateProductState {
  final String message;
  AddPostError({required this.message});
}