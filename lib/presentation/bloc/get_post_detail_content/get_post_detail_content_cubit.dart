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

  void clear() {
    emit(Empty());
  }

  void execute(String userId, String token) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());
        var user = await getUserById.call(userId, token);
        var products =
            await getFavoriteProducts.call(token, user.favoriteProducts);
        emit(Loaded(products, user));
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
