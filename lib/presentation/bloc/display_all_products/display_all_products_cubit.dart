import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_all_products.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_favorite_products.dart';
import 'display_all_products_state.dart';

class DisplayAllProductsCubit extends Cubit<DisplayAllProductsState> {
  final GetAllProducts getAllProducts;
  final GetAllCategories getAllCategories;
  final GetFavoriteProducts getFavoriteProducts;
  DisplayAllProductsCubit(
      this.getAllProducts, this.getAllCategories, this.getFavoriteProducts)
      : super(Empty());

  void call() async {
    try {
      emit(Empty());
      emit(Loading());
      var products = await getAllProducts.call();
      var favoriteProducts = await getFavoriteProducts.call();
      var categories = await getAllCategories.call();
      if (products.isNotEmpty && categories.isNotEmpty) {
        emit(Loaded(products, categories, favoriteProducts));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
