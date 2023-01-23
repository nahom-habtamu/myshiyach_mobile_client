import '../../data/models/product/product_model.dart';
import '../contracts/user_service.dart';

class UpdateFavoriteProducts {
  final UserService repository;

  UpdateFavoriteProducts(this.repository);

  Future<void> call(
      String id, String token, List<ProductModel> favoriteProducts) async {
    await repository.updateFavoriteProducts(
        id, token, favoriteProducts.map((e) => e.id).toList());
  }
}
