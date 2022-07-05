import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product/product_model.dart';
import '../../../domain/enitites/product.dart';
import '../../../domain/usecases/get_favorite_products.dart';
import '../../../domain/usecases/get_product_by_id.dart';
import '../../../domain/usecases/set_favorite_product.dart';
import 'get_favorite_products_state.dart';

class GetFavoriteProductsCubit extends Cubit<GetFavoriteProductsState> {
  final GetFavoriteProducts getFavoriteProducts;
  final SetFavoriteProducts setFavoriteProducts;
  final GetProductById getProductById;
  GetFavoriteProductsCubit({
    required this.getFavoriteProducts,
    required this.getProductById,
    required this.setFavoriteProducts,
  }) : super(Loading());

  void execute(String token) async {
    try {
      emit(Empty());
      emit(Loading());
      var products = await getFavoriteProducts.call();
      List<Product> checkedProducts =
          await _getExisingProducts(products, token);
      if (checkedProducts.isNotEmpty) {
        emit(Loaded(checkedProducts));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  Future<List<Product>> _getExisingProducts(
      List<Product> products, String token) async {
    List<Product> existingProducts = [...products];
    for (var product in products) {
      try {
        await getProductById.call(product.id, token);
      } catch (e) {
        existingProducts.removeWhere((element) => element.id == product.id);
      }
    }
    rewriteFavoriteProducts(existingProducts);
    return existingProducts;
  }

  void rewriteFavoriteProducts(List<Product> existingProducts) {
    var mappedToModel =
        existingProducts.map((e) => ProductModel.fromProduct(e)).toList();
    setFavoriteProducts.call(mappedToModel);
  }
}
