import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../data/models/product/page_and_limit_model.dart';
import '../../../domain/usecases/get_paginated_products.dart';
import 'get_paginated_products_state.dart';

class GetPaginatedProductsCubit extends Cubit<GetPaginatedProductsState> {
  final GetPaginatedProducts getPaginatedProducts;
  GetPaginatedProductsCubit(this.getPaginatedProducts) : super(Empty());

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
      var result =
          await getPaginatedProducts.call(pageAndLimit, filterCriteriaModel);
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
