import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product/page_and_limit_model.dart';
import '../../../domain/usecases/get_all_products.dart';
import 'get_all_products_state.dart';

class GetAllProductsCubit extends Cubit<GetAllProductsState> {
  final GetAllProducts getAllProducts;
  GetAllProductsCubit(this.getAllProducts) : super(Empty());

  void clear() {
    emit(Empty());
  }

  void call(PageAndLimitModel pageAndLimit) async {
    try {
      emit(Empty());
      emit(Loading());
      var result = await getAllProducts.call(pageAndLimit);
      if (result.products.isNotEmpty) {
        emit(Loaded(result));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
