import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_favorite_products.dart';
import '../../../domain/usecases/get_user_by_id.dart';
import 'get_post_detail_content_state.dart';

class GetPostDetailContentCubit extends Cubit<GetPostDetailContentState> {
  final GetFavoriteProducts getFavoriteProducts;
  final GetUserById getUserById;
  GetPostDetailContentCubit({
    required this.getFavoriteProducts,
    required this.getUserById,
  }) : super(Empty());

  void execute(
    String userId,
    String token,
  ) async {
    try {
      emit(Empty());
      emit(Loading());
      var products = await getFavoriteProducts.call();
      var user = await getUserById.call(userId, token);
      emit(Loaded(products, user));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
