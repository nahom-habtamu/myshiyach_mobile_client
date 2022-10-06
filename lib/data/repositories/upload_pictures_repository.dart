import '../../domain/contracts/upload_pictures_service.dart';
import '../datasources/firebase/firebase_storage_data_source.dart';

class UploadPicturesRepository extends UploadPicturesService {
  final StorageDataSource storageService;

  UploadPicturesRepository(this.storageService);

  @override
  Future<List<String>> uploadPictures(List images, String bucketName) {
    return storageService.uploadFiles(images, bucketName);
  }
}
