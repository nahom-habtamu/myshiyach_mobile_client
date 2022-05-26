import 'package:flutter/material.dart';

import 'change_input_state_button.dart';

class NextOrPostButton extends StatelessWidget {
  final int currentInputPageState;
  final bool isThereAdditionalData;
  final Function onTap;
  const NextOrPostButton(
      {Key? key,
      required this.currentInputPageState,
      required this.isThereAdditionalData, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChangeInputButton(
        text: currentInputPageState == 0 ||
                (currentInputPageState == 1 && isThereAdditionalData)
            ? "Next"
            : "Post",
        backgroundColor: const Color(0xFF010203),
        textColor: Colors.white,
        onTap: () {
          if (currentInputPageState == 0 ||
              (currentInputPageState == 1 && isThereAdditionalData)) {
              onTap(currentInputPageState + 1);
          } else {
            // Navigator.of(context).pushNamed()
          }
        },
      ),
    );
  }
}