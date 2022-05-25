abstract class SetFavroiteProductsState {}

class NotFired extends SetFavroiteProductsState {}

class Loading extends SetFavroiteProductsState {}

class Error extends SetFavroiteProductsState {
  final String message;
  Error({required this.message});
}
