import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/get_favorite_products.dart';
import '../../../domain/usecases/get_user_by_id.dart';
import 'get_post_detail_content_state.dart';

class GetPostDetailContentCubit extends Cubit<GetPostDetailContentState> {
  final GetFavoriteProducts getFavoriteProducts;
  final GetUserById getUserById;
  final NetworkInfo networkInfo;
  GetPostDetailContentCubit({
    required this.getFavoriteProducts,
    required this.getUserById,
    required this.networkInfo,
  }) : super(Empty());

  void execute(
      String userId, String token, List<String> favoriteProductsIds) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());
        var products =
            await getFavoriteProducts.call(token, favoriteProductsIds);
        var user = await getUserById.call(userId, token);
        emit(Loaded(products, user));
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
