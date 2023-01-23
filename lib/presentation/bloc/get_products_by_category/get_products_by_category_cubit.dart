import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/domain/usecases/get_favorite_products.dart';
import 'package:mnale_client/domain/usecases/get_user_by_id.dart';

import '../../../domain/usecases/get_products_by_category.dart';
import 'get_products_by_category_state.dart';

class GetProductsByCategoryCubit extends Cubit<GetProductsByCategoryState> {
  final GetProductsByCategory getProductsByCategory;
  final GetFavoriteProducts getFavoriteProducts;
  final GetUserById getUserById;
  GetProductsByCategoryCubit(
      this.getProductsByCategory, this.getFavoriteProducts, this.getUserById)
      : super(Empty());

  void clear() {
    emit(NotTriggered());
  }

  void call(String mainCategory, String subCategory, String token,
      String userId) async {
    try {
      emit(NotTriggered());
      emit(Loading());
      var products =
          await getProductsByCategory.call(mainCategory, subCategory);
      var user = await getUserById.call(userId, token);
      var favorites =
          await getFavoriteProducts.call(token, user.favoriteProducts);
      if (products.isNotEmpty) {
        emit(Loaded(products, favorites));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
