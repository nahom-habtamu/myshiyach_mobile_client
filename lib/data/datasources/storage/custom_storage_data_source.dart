import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../core/constants/api_information.dart';
import 'storage_data_source.dart';

class CustomStorageDataSource extends StorageDataSource {
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
    var filename = image.path.split("/").last;
    final uri = Uri.parse(
        '$baseUrl/upload/${bucketName == "product_images" ? 'productImage' : 'conversationImage'}');
    var request = http.MultipartRequest('POST', uri);
    final httpImage = await http.MultipartFile.fromPath(
      bucketName == "product_images" ? 'product-image' : 'conversation-image',
      image.path,
      filename: filename,
      contentType: MediaType("image", "png"),
    );
    request.files.add(httpImage);
    final response = await request.send();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var body = await response.stream.bytesToString();
      return body;
    }
    throw Exception("File Not Uploaded");
  }
}
