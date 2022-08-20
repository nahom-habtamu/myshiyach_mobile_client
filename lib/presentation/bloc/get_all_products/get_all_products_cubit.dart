import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../data/models/product/page_and_limit_model.dart';
import '../../../domain/usecases/get_all_products.dart';
import 'get_all_products_state.dart';

class GetAllProductsCubit extends Cubit<GetAllProductsState> {
  final GetAllProducts getAllProducts;
  GetAllProductsCubit(this.getAllProducts) : super(Empty());

  void clear() {
    emit(NotTriggered());
  }

  void call(
    PageAndLimitModel pageAndLimit,
    FilterCriteriaModel? filterCriteriaModel,
  ) async {
    try {
      emit(NotTriggered());
      emit(Loading());
      var result = await getAllProducts.call(pageAndLimit, filterCriteriaModel);
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
