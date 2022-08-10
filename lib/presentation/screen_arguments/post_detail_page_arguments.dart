import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';

class PostDetalPageArguments {
  final Product product;
  final bool isFromDynamicLink;
  final User? currentUser;
  final String? token;

  PostDetalPageArguments({
    required this.product,
    required this.isFromDynamicLink,
    this.currentUser,
    this.token,
  });
}
