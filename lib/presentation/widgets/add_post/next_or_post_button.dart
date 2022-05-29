import 'package:flutter/material.dart';

import 'change_input_state_button.dart';

class NextOrPostButton extends StatelessWidget {
  final bool isThereAdditionalData;
  final Function onTap;
  const NextOrPostButton(
      {Key? key, required this.isThereAdditionalData, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChangeInputButton(
        text: isThereAdditionalData ? "Next" : "Post",
        backgroundColor: const Color(0xFF010203),
        textColor: Colors.white,
        onTap: onTap,
      ),
    );
  }
}
