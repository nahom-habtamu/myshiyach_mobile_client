import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mnale_client/presentation/pages/chat_page.dart';

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
          title: const Text(
            'Post Detail',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              const PostDetailCarousel(
                items: [
                  'https://images.unsplash.com/photo-1653286015985-d4857eac5679?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=627',
                  'https://images.unsplash.com/photo-1653256471013-8613f0bf3b9b?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764',
                  'https://images.unsplash.com/photo-1653276526709-c424ad920de6?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765'
                ],
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 15,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '2007 2.5l automatic 4wd Nissan Elgrand Highway Star ULEZ',
                            style: TextStyle(
                              color: Color(0xff11435E),
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.timer_sharp,
                                color: Colors.grey,
                                size: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '26 days ago',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '£8,900.00',
                            style: TextStyle(
                              color: Color(0xff34A853),
                              fontSize: 24,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: Color(0xff11435E),
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "2007 Nissan Elgrand Highway Star 2.5L 4WD, ULEZ compliant, with part-leather interior. Manufactured December 2007. 76,450 Miles. MNE51 -160368 chassis no. This has been freshly imported from our trusted agent in Japan who sourced my original family car, and is a ‘4’ (out of 5 with this being the highest grade on their already meticulous grading system, with 5 usually reserved for cars under 10 years old) on the Japanese auction certificate. Four new tyres and hasn't been driven (except for keeping the battery charged) since.Will come with all original Japanese paperwork and invoices including auction sheet, invoices and bill of lading as well as spare key and Japanese log book and manual.Has had a full health check and MOT until 14/12/2022, fog light added by our import specialist mechanic.",
                            style: TextStyle(
                              color: Color(0xff434648),
                              fontSize: 12,
                              height: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  ChatListPage.routeName,
                                );
                              },
                              child: const Text('Send Message'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xff11435E),
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
            print("I AM CLICKED PREVIOUS");
            carouselController.previousPage(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
            );
          },
        ),
        CarouselImageChangerIcon(
          onClick: () {
            print("I AM CLICKED NEXT");
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

class CarouselImageChangerIcon extends StatelessWidget {
  final Function onClick;
  final bool isRightArrow;
  const CarouselImageChangerIcon({
    Key? key,
    this.isRightArrow = false,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: isRightArrow ? MediaQuery.of(context).size.width * 0.8 : 0,
      left: !isRightArrow ? MediaQuery.of(context).size.width * 0.8 : 0,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.black54,
        child: IconButton(
          onPressed: () {
            onClick();
          },
          icon: Icon(
            isRightArrow
                ? Icons.arrow_back_ios_new_outlined
                : Icons.arrow_forward_ios_outlined,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class PageCounter extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  const PageCounter({
    Key? key,
    required this.pageCount,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      left: 15,
      child: Container(
        height: 35,
        width: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.photo_camera_back_rounded,
              color: Colors.white,
            ),
            Text(
              '${currentPage + 1} of $pageCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          color: Color(0xB9000000),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
