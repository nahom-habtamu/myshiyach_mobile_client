import 'package:flutter/material.dart';

class PostImagesScreen extends StatelessWidget {
  static String routeName = "/postImagesScreen";
  const PostImagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var images = ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) => InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 1,
          maxScale: 5,
          child: Image.network(
            images.elementAt(index),
            fit: BoxFit.contain,
          ),
        ),
      ),
    ));
  }
}
