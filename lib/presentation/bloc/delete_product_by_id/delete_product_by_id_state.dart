abstract class DeleteProductByIdState {}

class DeleteProductEmpty extends DeleteProductByIdState {}

class DeleteProductLoading extends DeleteProductByIdState {}

class DeleteProductLoaded extends DeleteProductByIdState {
  final String id;
  DeleteProductLoaded(this.id);
}

class DeleteProductError extends DeleteProductByIdState {
  final String message;
  DeleteProductError({required this.message});
}
