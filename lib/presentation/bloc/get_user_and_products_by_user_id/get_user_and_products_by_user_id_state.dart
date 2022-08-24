import '../../../domain/enitites/product.dart';
import '../../../domain/enitites/user.dart';

abstract class GetUserAndProductsByUserIdState {}

class GetUserAndProductsByUserIdEmpty extends GetUserAndProductsByUserIdState {}

class GetUserAndProductsByUserIdLoading
    extends GetUserAndProductsByUserIdState {}

class GetUserAndProductsByUserIdNoNetwork
    extends GetUserAndProductsByUserIdState {}

class GetUserAndProductsByUserIdLoaded extends GetUserAndProductsByUserIdState {
  final List<Product> products;
  final List<Product> favorites;
  final User user;
  GetUserAndProductsByUserIdLoaded({
    required this.products,
    required this.user,
    required this.favorites,
  });
}

class GetUserAndProductsByUserIdError extends GetUserAndProductsByUserIdState {
  final String message;
  GetUserAndProductsByUserIdError({required this.message});
}
