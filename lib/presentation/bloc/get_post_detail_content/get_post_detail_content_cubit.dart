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

  void execute(String productOwnerId, String currentUserId, String token) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());
        var currentUser = await getUserById.call(productOwnerId, token);
        var user = await getUserById.call(currentUserId, token);
        emit(Loaded(user.favoriteProducts, currentUser));
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
