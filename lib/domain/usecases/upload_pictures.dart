import '../contracts/upload_pictures_service.dart';

class UploadPictures {
  final UploadPicturesService repository;

  UploadPictures(this.repository);

  Future<List<String>> call(List<dynamic> images, String bucketName) async {
    var result = await repository.uploadPictures(images, bucketName);
    return result;
  }
}
