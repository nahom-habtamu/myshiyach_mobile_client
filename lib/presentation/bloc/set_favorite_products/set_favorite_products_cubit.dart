import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product/product_model.dart';
import '../../../domain/usecases/set_favorite_product.dart';
import 'set_favorite_products_state.dart';

class SetFavoriteProductsCubit extends Cubit<SetFavroiteProductsState> {
  final SetFavoriteProducts setFavoriteProducts;
  SetFavoriteProductsCubit(this.setFavoriteProducts) : super(NotFired());

  void execute(List<ProductModel> favoriteProducts) async {
    try {
      emit(Loading());
      await setFavoriteProducts.call(favoriteProducts);
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
