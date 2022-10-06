import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageDataSource {
  Future<List<String>> uploadFiles(List<dynamic> images, String bucketName);
}

class FirebaseStorageDataSource extends StorageDataSource {
  @override
  Future<List<String>> uploadFiles(List images, String bucketName) async {
    var result = await uploadAllImages(images, bucketName);
    return result;
  }

  Future<List<String>> uploadAllImages(
    List<dynamic> images,
    String bucketName,
  ) async {
    List<String> uploadedFiles = [];

    for (var i = 0; i < images.length; i++) {
      String myUrl = await uploadSingleImage(images[i], bucketName);
      uploadedFiles = [...uploadedFiles, myUrl];
    }
    return uploadedFiles;
  }

  Future<String> uploadSingleImage(dynamic image, String bucketName) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child(bucketName)
        .child(DateTime.now().toString() + ".jpg");

    File file = File(image.path);
    var task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }
}
