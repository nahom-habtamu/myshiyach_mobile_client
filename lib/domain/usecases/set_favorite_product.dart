import '../../data/models/product/product_model.dart';
import '../contracts/product_service.dart';

class SetFavoriteProducts {
  final ProductService repository;

  SetFavoriteProducts(this.repository);

  Future<void> call(List<ProductModel> favoriteProducts) async {
    await repository.setFavoriteProducts(favoriteProducts);
  }
}
