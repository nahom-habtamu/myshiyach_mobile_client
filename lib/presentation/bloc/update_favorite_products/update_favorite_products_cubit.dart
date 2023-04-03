import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/update_favorite_product.dart';
import 'update_favorite_products_state.dart';

class UpdateFavoriteProductsCubit extends Cubit<UpdateFavoriteProductsState> {
  final UpdateFavoriteProducts updateFavoriteProducts;
  UpdateFavoriteProductsCubit(this.updateFavoriteProducts) : super(NotFired());

  void execute(String id, String token, List<String> favoriteProducts) async {
    try {
      emit(Loading());
      await updateFavoriteProducts.call(id, token, favoriteProducts);
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
