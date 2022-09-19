import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../data/models/product/page_and_limit_model.dart';
import '../../../domain/enitites/product.dart';
import '../../../domain/usecases/get_paginated_products.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_favorite_products.dart';
import 'display_all_products_state.dart';

class DisplayAllProductsCubit extends Cubit<DisplayAllProductsState> {
  final GetPaginatedProducts getAllProducts;
  final GetAllCategories getAllCategories;
  final GetFavoriteProducts getFavoriteProducts;
  final NetworkInfo networkInfo;
  DisplayAllProductsCubit(
    this.getAllProducts,
    this.getAllCategories,
    this.getFavoriteProducts,
    this.networkInfo,
  ) : super(Empty());

  int _compareCreatedAt(Product a, Product b) {
    var firstDate = DateFormatterUtil.parseProductCreatedDate(a.refreshedAt);
    var secondDate = DateFormatterUtil.parseProductCreatedDate(b.refreshedAt);
    return secondDate.compareTo(firstDate);
  }

  void clear() {
    emit(Empty());
  }

  void call(
    PageAndLimitModel pageAndLimit,
    FilterCriteriaModel? filterCriteriaModel,
  ) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());
        var result =
            await getAllProducts.call(pageAndLimit, filterCriteriaModel);
        var favoriteProducts = await getFavoriteProducts.call();
        var categories = await getAllCategories.call();
        if (result.products.isNotEmpty && categories.isNotEmpty) {
          emit(Loaded(result, categories, favoriteProducts));
        } else {
          emit(Empty());
        }
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  void sortProductByCreatedTime(List<Product> products) =>
      products.sort((a, b) => _compareCreatedAt(a, b));
}
