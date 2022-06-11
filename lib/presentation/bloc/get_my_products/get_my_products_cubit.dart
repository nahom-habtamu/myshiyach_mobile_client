import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_products.dart';
import 'get_my_products_state.dart';

class GetMyProductsCubit extends Cubit<GetMyProductsState> {
  final GetMyProducts getMyProducts;
  GetMyProductsCubit(this.getMyProducts) : super(GetMyProductsEmpty());

  void call(String userId) async {
    try {
      emit(GetMyProductsEmpty());
      emit(GetMyProductsLoading());
      var products = await getMyProducts.call(userId);
      if (products.isNotEmpty) {
        emit(GetMyProductsLoaded(products));
      } else {
        emit(GetMyProductsEmpty());
      }
    } catch (e) {
      emit(GetMyProductsError(message: e.toString()));
    }
  }
}
