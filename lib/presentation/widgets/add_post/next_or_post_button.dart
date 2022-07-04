import 'package:flutter/material.dart';

import 'change_input_state_button.dart';

class PostButton extends StatelessWidget {
  final bool isPost;
  final Function onTap;
  const PostButton({Key? key, required this.onTap, this.isPost = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeInputButton(
      text: isPost ? "Post" : "Next",
      backgroundColor: const Color(0xff11435E),
      textColor: Colors.white,
      onTap: onTap,
    );
  }
}
