import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/get_products_by_user_id.dart';
import '../../../domain/usecases/get_user_by_id.dart';
import 'get_user_and_products_by_user_id_state.dart';

class GetUserAndProductsByUserIdCubit
    extends Cubit<GetUserAndProductsByUserIdState> {
  final GetProductsByUserId getMyProducts;
  final GetUserById getUserById;
  final NetworkInfo networkInfo;
  GetUserAndProductsByUserIdCubit({
    required this.getMyProducts,
    required this.networkInfo,
    required this.getUserById,
  }) : super(GetUserAndProductsByUserIdEmpty());

  void call(String userId, String token) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(GetUserAndProductsByUserIdEmpty());
        emit(GetUserAndProductsByUserIdLoading());
        var user = await getUserById.call(userId, token);
        var products = await getMyProducts.call(userId);
        if (products.isNotEmpty) {
          emit(GetUserAndProductsByUserIdLoaded(products, user));
        } else {
          emit(GetUserAndProductsByUserIdEmpty());
        }
      } else {
        emit(GetUserAndProductsByUserIdNoNetwork());
      }
    } catch (e) {
      emit(GetUserAndProductsByUserIdError(message: e.toString()));
    }
  }
}
