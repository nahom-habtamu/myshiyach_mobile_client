import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../pages/post_image_screen.dart';
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
        renderOneImageFallBack(),
        renderCarouselSlider(),
        PageCounter(
          currentPage: currentCarouselIndex,
          pageCount: widget.items.length,
        ),
        Visibility(
          visible: showCarousel,
          child: CarouselImageChangerIcon(
            isRightArrow: true,
            onClick: () {
              carouselController.previousPage(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        Visibility(
          visible: showCarousel,
          child: CarouselImageChangerIcon(
            onClick: () {
              carouselController.nextPage(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ],
    );
  }

  bool get showCarousel => widget.items.length > 1;

  renderOneImageFallBack() {
    return Visibility(
      visible: !showCarousel,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              PostImagesScreen.routeName,
              arguments: widget.items,
            );
          },
          child: Image.network(
            widget.items.first,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  renderCarouselSlider() {
    return Visibility(
      visible: widget.items.length > 1,
      child: CarouselSlider(
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
            .map(
              (item) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PostImagesScreen.routeName,
                    arguments: widget.items,
                  );
                },
                child: Image.network(
                  item,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
