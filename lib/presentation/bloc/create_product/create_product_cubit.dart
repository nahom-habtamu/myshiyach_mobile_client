import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_product_state.dart';
import '../../../data/models/product/add_product_model.dart';
import '../../../domain/usecases/create_product.dart';
import '../../../domain/usecases/upload_product_pictures.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final CreateProduct createProduct;
  final UploadProductPictures uploadProductPictures;
  CreateProductCubit(
      {required this.createProduct, required this.uploadProductPictures})
      : super(AddPostNotTriggered());

  void call(AddProductModel addProductModel, List<dynamic> productImages, String token) async {
    try {
      emit(AddPostNotTriggered());
      emit(AddPostLoading());
      var uploadedPictures = await uploadProductPictures.call(productImages);
      addProductModel.productImages = [...uploadedPictures];
      var product = await createProduct.call(addProductModel, token);
      emit(AddPostSuccessfull(product));
    } catch (e) {
      emit(AddPostError(message: e.toString()));
    }
  }
}
