import 'package:flutter/material.dart';

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