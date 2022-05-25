import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_favorite_products.dart';
import 'get_favorite_products_state.dart';

class GetFavoriteProductsCubit extends Cubit<GetFavoriteProductsState> {
  final GetFavoriteProducts getFavoriteProducts;
  GetFavoriteProductsCubit(this.getFavoriteProducts) : super(Loading());

  void execute() async {
    try {
      emit(Empty());
      emit(Loading());
      var products = await getFavoriteProducts.call();
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
