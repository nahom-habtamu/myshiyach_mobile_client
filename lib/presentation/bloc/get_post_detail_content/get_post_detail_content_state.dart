import '../../../domain/enitites/product.dart';
import '../../../domain/enitites/user.dart';

abstract class GetPostDetailContentState {}

class Empty extends GetPostDetailContentState {}

class Loading extends GetPostDetailContentState {}

class NoNetwork extends GetPostDetailContentState {}

class Loaded extends GetPostDetailContentState {
  final List<Product> favoriteProducts;
  final User postCreator;
  Loaded(this.favoriteProducts, this.postCreator);
}

class Error extends GetPostDetailContentState {
  final String message;
  Error({required this.message});
}
