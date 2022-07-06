import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../domain/enitites/product.dart';
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

  int _compareCreatedAt(Product a, Product b) {
    var firstDate = DateFormatterUtil.parseProductCreatedDate(a.createdAt);
    var secondDate = DateFormatterUtil.parseProductCreatedDate(b.createdAt);
    return secondDate.compareTo(firstDate);
  }

  void call() async {
    try {
      emit(Empty());
      emit(Loading());
      var products = await getAllProducts.call();
      var favoriteProducts = await getFavoriteProducts.call();
      var categories = await getAllCategories.call();
      if (products.isNotEmpty && categories.isNotEmpty) {
        sortProductByCreatedTime(products);
        emit(Loaded(products, categories, favoriteProducts));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
      rethrow;
    }
  }

  void sortProductByCreatedTime(List<Product> products) =>
      products.sort((a, b) => _compareCreatedAt(a, b));
}
