import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_all_products.dart';
import 'get_all_products_state.dart';

class GetAllProductsCubit extends Cubit<GetAllProductsState> {
  final GetAllProducts getAllProducts;
  GetAllProductsCubit(this.getAllProducts) : super(Empty());

  void call() async {
    try {
      emit(Empty());
      emit(Loading());
      var products = await getAllProducts.call();
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
