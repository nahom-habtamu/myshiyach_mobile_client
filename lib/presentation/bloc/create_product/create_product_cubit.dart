import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_product_state.dart';
import '../../../data/models/product/add_product_model.dart';
import '../../../domain/usecases/create_product.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final CreateProduct createProduct;
  CreateProductCubit(this.createProduct) : super(AddPostNotTriggered());

  void call(AddProductModel addProductModel) async {
    try {
      emit(AddPostNotTriggered());
      emit(AddPostLoading());
      var product = await createProduct.call(addProductModel);
      emit(AddPostSuccessfull(product));
    } catch (e) {
      emit(AddPostError(message: e.toString()));
    }
  }
}
