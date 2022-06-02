import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageDataSource {
  Future<List<String>> uploadFiles(List<dynamic> images);
}

class FirebaseStorageDataSource extends StorageDataSource {
  @override
  Future<List<String>> uploadFiles(List images) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("product_images")
        .child(DateTime.now().toString() + ".jpg");
    var result = await uploadAllImages(images, ref);
    return result;
  }

  Future<List<String>> uploadAllImages(
      List<dynamic> images, Reference ref) async {
    List<String> result = [];

    for (var i = 0; i < images.length; i++) {
      String url = await uploadSingleImage(images[i], ref);
      result.add(url);
    }
    return result;
  }

  Future<String> uploadSingleImage(dynamic image, Reference ref) async {
    File file = File(image.path);
    var task = await ref.putFile(file);
    var url = await task.ref.getDownloadURL();
    return url;
  }
}
