import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../data/models/product/product_model.dart';
import '../../../domain/enitites/product.dart';
import '../../../domain/usecases/get_favorite_products.dart';
import '../../../domain/usecases/get_product_by_id.dart';
import 'get_favorite_products_state.dart';

class GetFavoriteProductsCubit extends Cubit<GetFavoriteProductsState> {
  final GetFavoriteProducts getFavoriteProducts;
  final GetProductById getProductById;
  final NetworkInfo networkInfo;
  GetFavoriteProductsCubit(
      {required this.getFavoriteProducts,
      required this.getProductById,
      required this.networkInfo})
      : super(Loading());

  void execute(String token, List<String> favoriteProductsIds) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());
        var products =
            await getFavoriteProducts.call(token, favoriteProductsIds);
        emit(Loaded(products));
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
