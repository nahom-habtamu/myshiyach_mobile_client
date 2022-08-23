import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_products_by_category.dart';
import 'get_products_by_category_state.dart';

class GetProductsByCategoryCubit extends Cubit<GetProductsByCategoryState> {
  final GetProductsByCategory getProductsByCategory;
  GetProductsByCategoryCubit(this.getProductsByCategory) : super(Empty());

  void clear() {
    emit(NotTriggered());
  }

  void call(
    String mainCategory,
    String subCategory,
  ) async {
    try {
      emit(NotTriggered());
      emit(Loading());
      var products =
          await getProductsByCategory.call(mainCategory, subCategory);
      if (products.isNotEmpty) {
        emit(Loaded(products));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
