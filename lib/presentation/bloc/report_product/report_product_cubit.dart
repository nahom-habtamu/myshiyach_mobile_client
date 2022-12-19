import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/report_product.dart';
import 'report_product_state.dart';

class ReportProductCubit extends Cubit<ReportProductState> {
  final ReportProduct refreshProduct;
  final NetworkInfo networkInfo;
  ReportProductCubit(this.refreshProduct, this.networkInfo)
      : super(ReportPostEmpty());

  void clear() {
    emit(ReportPostEmpty());
  }

  void call(
    String id,
    String token,
  ) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(ReportPostEmpty());
        emit(ReportPostLoading());
        var product = await refreshProduct.call(id, token);
        emit(ReportPostSuccessfull(product));
      } else {
        emit(ReportPostNoNetwork());
      }
    } catch (e) {
      emit(ReportPostError(message: e.toString()));
    }
  }
}
