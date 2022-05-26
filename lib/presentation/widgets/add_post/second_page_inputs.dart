import 'package:flutter/material.dart';

import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'modal_sheet_image_picker.dart';

class SecondPageInputs extends StatelessWidget {
  const SecondPageInputs({
    Key? key,
    required this.subCategoriesToDisplay,
  }) : super(key: key);

  final List<String> subCategoriesToDisplay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddPostDropDownInput(
          hintText: "Post State",
          items: ["New", "Old", "Slightly Used"],
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostDropDownInput(
          hintText: "Sub Category",
          items: [...subCategoriesToDisplay],
        ),
        const SizedBox(
          height: 30,
        ),
        const AddPostInput(
          hintText: "Contact Phone",
        ),
        const SizedBox(
          height: 30,
        ),
        const ModalSheetImagePicker(
          hintText: "Images",
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}