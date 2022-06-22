import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product/edit_product_model.dart';
import '../../../domain/usecases/update_product.dart';
import '../../../domain/usecases/upload_product_pictures.dart';
import 'update_product_state.dart';

class UpdateProductCubit extends Cubit<UpdateProductState> {
  final UpdateProduct updateProduct;
  final UploadProductPictures uploadProductPictures;
  UpdateProductCubit({
    required this.updateProduct,
    required this.uploadProductPictures,
  }) : super(EditPostEmpty());

  void clear() {
    emit(EditPostEmpty());
  }

  void call(
    String id,
    EditProductModel editProductModel,
    List<dynamic> imagesToUpload,
    List<dynamic> productImages,
    String token,
  ) async {
    try {
      emit(EditPostEmpty());
      emit(EditPostLoading());
      if (imagesToUpload.isNotEmpty) {
        var uploadedPictures = await uploadProductPictures.call(imagesToUpload);
        editProductModel.productImages = [
          ...uploadedPictures,
          ...productImages
        ];
      } else {
        editProductModel.productImages = [...productImages];
      }
      var product = await updateProduct.call(id, editProductModel, token);
      emit(EditPostSuccessfull(product));
    } catch (e) {
      emit(EditPostError(message: e.toString()));
    }
  }
}
