import 'package:flutter/material.dart';

class EmptyStateContent extends StatelessWidget {
  final String captionText;
  final Function onButtonClicked;
  final String hintText;
  final String buttonText;
  const EmptyStateContent({
    Key? key,
    required this.captionText,
    required this.onButtonClicked,
    required this.hintText,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            captionText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            hintText,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              onButtonClicked();
            },
            child: Text(buttonText),
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
        )
      ],
    );
  }
}
