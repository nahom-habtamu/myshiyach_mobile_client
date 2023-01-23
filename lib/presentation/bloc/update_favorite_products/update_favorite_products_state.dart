abstract class UpdateFavoriteProductsState {}

class NotFired extends UpdateFavoriteProductsState {}

class Loading extends UpdateFavoriteProductsState {}

class Error extends UpdateFavoriteProductsState {
  final String message;
  Error({required this.message});
}
