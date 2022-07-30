import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/refresh_product.dart';
import 'refresh_product_state.dart';

class RefreshProductCubit extends Cubit<RefreshProductState> {
  final RefreshProduct refreshProduct;
  final NetworkInfo networkInfo;
  RefreshProductCubit(this.refreshProduct, this.networkInfo)
      : super(RefreshPostEmpty());

  void clear() {
    emit(RefreshPostEmpty());
  }

  void call(
    String id,
    String token,
  ) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(RefreshPostEmpty());
        emit(RefreshPostLoading());
        var product = await refreshProduct.call(id, token);
        emit(RefreshPostSuccessfull(product));
      } else {
        emit(RefreshPostNoNetwork());
      }
    } catch (e) {
      emit(RefreshPostError(message: e.toString()));
    }
  }
}
