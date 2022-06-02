import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/delete_product_by_id.dart';
import 'delete_product_by_id_state.dart';

class DeleteProductByIdCubit extends Cubit<DeleteProductByIdState> {
  final DeleteProductById deleteProductById;
  DeleteProductByIdCubit(this.deleteProductById) : super(DeleteProductEmpty());

  void call(String id, String token) async {
    try {
      emit(DeleteProductEmpty());
      emit(DeleteProductLoading());
      var deletedProductId = await deleteProductById.call(id, token);
      emit(DeleteProductLoaded(deletedProductId));
    } catch (e) {
      emit(DeleteProductError(message: e.toString()));
    }
  }
}
