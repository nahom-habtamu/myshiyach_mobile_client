import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/refresh_product.dart';
import 'refresh_product_state.dart';

class RefreshProductCubit extends Cubit<RefreshProductState> {
  final RefreshProduct refreshProduct;
  RefreshProductCubit(
    this.refreshProduct,
  ) : super(RefreshPostEmpty());

  void clear() {
    emit(RefreshPostEmpty());
  }

  void call(
    String id,
    String token,
  ) async {
    try {
      emit(RefreshPostEmpty());
      emit(RefreshPostLoading());
      var product = await refreshProduct.call(id, token);
      emit(RefreshPostSuccessfull(product));
    } catch (e) {
      emit(RefreshPostError(message: e.toString()));
    }
  }
}
