import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color? backgroundColor;
  final bool halfWidth;
  final bool isCurved;
  const ActionButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.halfWidth = false,
    this.isCurved = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.87;
    return SizedBox(
      height: 50,
      width: halfWidth ? width * 0.49 : width,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(text),
        style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? const Color(0xff11435E),
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(isCurved ? 16 : 0),
            ),
          ),
        ),
      ),
    );
  }
}
