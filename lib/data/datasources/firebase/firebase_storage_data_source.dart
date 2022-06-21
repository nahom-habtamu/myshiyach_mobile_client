import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageDataSource {
  Future<List<String>> uploadFiles(List<dynamic> images);
}

class FirebaseStorageDataSource extends StorageDataSource {
  @override
  Future<List<String>> uploadFiles(List images) async {
    var result = await uploadAllImages(images);
    return result;
  }

  Future<List<String>> uploadAllImages(
      List<dynamic> images) async {
    List<String> uploadedFiles = [];

    for (var i = 0; i < images.length; i++) {
      String myUrl = await uploadSingleImage(images[i]);
      uploadedFiles = [...uploadedFiles, myUrl];
    }
    return uploadedFiles;
  }

  Future<String> uploadSingleImage(dynamic image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("product_images")
        .child(DateTime.now().toString() + ".jpg");

    File file = File(image.path);
    var task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }
}
