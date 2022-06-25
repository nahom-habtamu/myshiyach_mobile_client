import 'package:flutter/material.dart';

class PostImageScreen extends StatelessWidget {
  static String routeName = "/postImagesScreen";
  const PostImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageUrl = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
