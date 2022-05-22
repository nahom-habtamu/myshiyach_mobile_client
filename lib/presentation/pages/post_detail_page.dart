import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


import '../../domain/enitites/product.dart';

class PostDetailPage extends StatelessWidget {
  static String routeName = "/postDetail";
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Product;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Detail'),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )
          ),
          child: Column(
            children: const [

            ],
          ),
        ),
      ),
    );
  }
}
