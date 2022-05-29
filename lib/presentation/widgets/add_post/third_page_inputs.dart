import 'package:flutter/material.dart';

import 'add_post_input.dart';
import 'cancel_button.dart';
import 'next_or_post_button.dart';

class ThirdPageInputs extends StatefulWidget {
  final List<String> additionalData;
  final Function onCancel;
  final Function onPost;
  const ThirdPageInputs(
      {Key? key,
      required this.additionalData,
      required this.onCancel,
      required this.onPost})
      : super(key: key);

  @override
  State<ThirdPageInputs> createState() => _ThirdPageInputsState();
}

class _ThirdPageInputsState extends State<ThirdPageInputs> {
  Map<String, dynamic> thirdInputValues = {};

  updateStateOnInputChange(String inputKey, String inputValue) {
    setState(() {
      thirdInputValues = {...thirdInputValues, inputKey: inputValue};
    });
  }

  @override
  Widget build(BuildContext context) {
    var additionalInputs = widget.additionalData.map(
      (e) => Column(
        children: [
          AddPostInput(
            hintText: e,
            onChanged: (value) => {updateStateOnInputChange(e, value)},
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
    return Column(
      children: [
        ...additionalInputs,
        Row(
          children: [
            CancelButton(onTap: widget.onCancel),
            NextOrPostButton(
              isThereAdditionalData: false,
              onTap: () {
                widget.onPost(thirdInputValues);
              },
            )
          ],
        )
      ],
    );
  }
}
