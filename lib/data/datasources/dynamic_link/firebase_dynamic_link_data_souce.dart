import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

abstract class DynamicLinkDataSource {
  Future<String> generateDynamicLink(String uniqueId);
}

class FirebaseDynamicLinkDataSource extends DynamicLinkDataSource {
  @override
  Future<String> generateDynamicLink(String uniqueId) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.example.com?productId=$uniqueId"),
      uriPrefix: "https://myshiyachapp.page.link",
      longDynamicLink: Uri.parse(
          "https://myshiyachapp.page.link/?link=https://www.example.com?productId%3D$uniqueId&apn=com.nahomhabtamu.mnale_client&afl=https://www.example.com/?productId%3D$uniqueId"),
      androidParameters: const AndroidParameters(
        packageName: "com.nahomhabtamu.mnale_client",
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    return dynamicLink.toString();
  }
}
