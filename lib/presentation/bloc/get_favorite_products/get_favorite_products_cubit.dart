import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/domain/usecases/get_user_by_id.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/get_favorite_products.dart';
import '../../../domain/usecases/get_product_by_id.dart';
import 'get_favorite_products_state.dart';

class GetFavoriteProductsCubit extends Cubit<GetFavoriteProductsState> {
  final GetFavoriteProducts getFavoriteProducts;
  final GetProductById getProductById;
  final GetUserById getUserById;
  final NetworkInfo networkInfo;
  GetFavoriteProductsCubit({
    required this.getFavoriteProducts,
    required this.getProductById,
    required this.getUserById,
    required this.networkInfo,
  }) : super(Loading());

  void execute(String token, String userId) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());
        var user = await getUserById.call(userId, token);
        var products =
            await getFavoriteProducts.call(token, user.favoriteProducts);
        emit(Loaded(products));
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
