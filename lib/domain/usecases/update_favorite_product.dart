import '../contracts/user_service.dart';

class UpdateFavoriteProducts {
  final UserService repository;

  UpdateFavoriteProducts(this.repository);

  Future<void> call(
      String id, String token, List<String> favoriteProducts) async {
    await repository.updateFavoriteProducts(
      id,
      token,
      favoriteProducts,
    );
  }
}
