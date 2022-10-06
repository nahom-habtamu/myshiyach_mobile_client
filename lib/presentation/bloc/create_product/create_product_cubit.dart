import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_product_state.dart';
import '../../../data/models/product/add_product_model.dart';
import '../../../domain/usecases/create_product.dart';
import '../../../domain/usecases/upload_pictures.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final CreateProduct createProduct;
  final UploadPictures uploadPictures;
  CreateProductCubit({
    required this.createProduct,
    required this.uploadPictures,
  }) : super(AddPostEmpty());

  void clear() {
    emit(AddPostEmpty());
  }

  void call(AddProductModel addProductModel, List<dynamic> productImages,
      String token) async {
    try {
      emit(AddPostEmpty());
      emit(AddPostLoading());
      var uploadedPictures = await uploadPictures.call(
        productImages,
        "product_images",
      );
      addProductModel.productImages = [...uploadedPictures];
      var product = await createProduct.call(addProductModel, token);
      emit(AddPostSuccessfull(product));
    } catch (e) {
      emit(AddPostError(message: e.toString()));
    }
  }
}
