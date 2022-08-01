import 'package:flutter/material.dart';

class IntroPageProgressIndicatorBubble extends StatelessWidget {
  final bool isActive;
  const IntroPageProgressIndicatorBubble({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: !isActive ? 9 : 28,
      height: 9,
      decoration: BoxDecoration(
        color: !isActive ? Colors.grey : const Color(0xFF11435E),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
