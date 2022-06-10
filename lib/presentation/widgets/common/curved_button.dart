import 'package:flutter/material.dart';

class CurvedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color? backgroundColor;
  final bool halfWidth;
  const CurvedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.halfWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 50,
      width: halfWidth ? width * 0.42 : width,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(text),
        style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? const Color(0xff11435E),
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
    );
  }
}
