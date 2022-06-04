import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'carousel_image_changer_icon.dart';
import 'page_counter.dart';

class PostDetailCarousel extends StatefulWidget {
  final List<String> items;
  const PostDetailCarousel({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<PostDetailCarousel> createState() => _PostDetailCarouselState();
}

class _PostDetailCarouselState extends State<PostDetailCarousel> {
  int currentCarouselIndex = 0;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider(
          carouselController: carouselController,
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentCarouselIndex = index;
              });
            },
          ),
          items: widget.items
              .map((item) => Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ))
              .toList(),
        ),
        PageCounter(
          currentPage: currentCarouselIndex,
          pageCount: widget.items.length,
        ),
        CarouselImageChangerIcon(
          isRightArrow: true,
          onClick: () {
            carouselController.previousPage(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
            );
          },
        ),
        CarouselImageChangerIcon(
          onClick: () {
            carouselController.nextPage(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}