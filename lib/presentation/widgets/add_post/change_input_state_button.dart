import 'package:flutter/material.dart';

class ChangeInputButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  const ChangeInputButton({
    Key? key,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.grey,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.40,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
