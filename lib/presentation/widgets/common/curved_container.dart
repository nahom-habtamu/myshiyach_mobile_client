import 'package:flutter/material.dart';

class CurvedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const CurvedContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.only(
      left: 15,
      right: 15,
      bottom: 10,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: padding,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 60,
      child: child,
    );
  }
}
