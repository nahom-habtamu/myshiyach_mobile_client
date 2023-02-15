abstract class StorageDataSource {
  Future<List<String>> uploadFiles(List<dynamic> images, String bucketName);
}
