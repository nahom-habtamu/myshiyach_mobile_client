abstract class UploadPicturesService {
  Future<List<String>> uploadPictures(
    List<dynamic> images,
    String bucketName,
  );
}
