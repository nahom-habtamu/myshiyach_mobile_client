import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/get_products_by_user_id.dart';
import 'get_products_by_user_id_state.dart';

class GetProductsByUserIdCubit extends Cubit<GetProductsByUserIdState> {
  final GetProductsByUserId getProductsByUserId;
  final NetworkInfo networkInfo;
  GetProductsByUserIdCubit({
    required this.getProductsByUserId,
    required this.networkInfo,
  }) : super(GetProductsByUserIdEmpty());

  void call(String userId) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(GetProductsByUserIdEmpty());
        emit(GetProductsByUserIdLoading());
        var products = await getProductsByUserId.call(userId);
        if (products.isNotEmpty) {
          emit(GetProductsByUserIdLoaded(products));
        } else {
          emit(GetProductsByUserIdEmpty());
        }
      } else {
        emit(GetProductsByUserIdNoNetwork());
      }
    } catch (e) {
      emit(GetProductsByUserIdError(message: e.toString()));
    }
  }
}
