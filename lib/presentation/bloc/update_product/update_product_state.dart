import '../../../domain/enitites/product.dart';

abstract class UpdateProductState {}

class EditPostEmpty extends UpdateProductState {}

class EditPostLoading extends UpdateProductState {}

class EditPostNoNetwork extends UpdateProductState {}

class EditPostSuccessfull extends UpdateProductState {
  final Product product;
  EditPostSuccessfull(this.product);
}

class EditPostError extends UpdateProductState {
  final String message;
  EditPostError({required this.message});
}
