import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/get_my_products.dart';
import 'get_my_products_state.dart';

class GetMyProductsCubit extends Cubit<GetMyProductsState> {
  final GetMyProducts getMyProducts;
  final NetworkInfo networkInfo;
  GetMyProductsCubit(this.getMyProducts, this.networkInfo)
      : super(GetMyProductsEmpty());

  void call(String userId) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(GetMyProductsEmpty());
        emit(GetMyProductsLoading());
        var products = await getMyProducts.call(userId);
        if (products.isNotEmpty) {
          emit(GetMyProductsLoaded(products));
        } else {
          emit(GetMyProductsEmpty());
        }
      } else {
        emit(GetMyProductsNoNetwork());
      }
    } catch (e) {
      emit(GetMyProductsError(message: e.toString()));
    }
  }
}
