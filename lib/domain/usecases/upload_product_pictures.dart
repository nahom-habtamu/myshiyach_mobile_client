import '../contracts/product_service.dart';

class UploadProductPictures {
  final ProductService repository;

  UploadProductPictures(this.repository);

  Future<List<String>> call(List<dynamic> images) async {
    var result = await repository.uploadProductPictures(images);
    return result;
  }
}
