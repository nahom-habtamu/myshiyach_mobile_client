import 'package:flutter/material.dart';
import 'package:mnale_client/domain/enitites/sub_category.dart';

import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'cancel_button.dart';
import 'input_image_picker.dart';
import 'next_or_post_button.dart';

class SecondPageInputs extends StatefulWidget {
  final List<SubCategory> subCategoriesToDisplay;
  final Function onCancel;
  final Function onPostOrNext;
  final bool isThereAdditionalData;

  const SecondPageInputs({
    Key? key,
    required this.subCategoriesToDisplay,
    required this.onCancel,
    required this.onPostOrNext,
    required this.isThereAdditionalData,
  }) : super(key: key);

  @override
  State<SecondPageInputs> createState() => _SecondPageInputsState();
}

class _SecondPageInputsState extends State<SecondPageInputs> {
  Map<String, dynamic> secondInputValues = {};

  updateStateOnInputChange(String inputKey, String inputValue) {
    print("INPUT KEY " + inputKey + " WITH VALUE " + inputValue + " ADDED ");
    setState(() {
      secondInputValues = {...secondInputValues, inputKey: inputValue};
    });
  }

  @override
  Widget build(BuildContext context) {
    var postStateToShowOnDropdown = ["New", "Old", "Slightly Used"]
        .map((m) => {"value": m, "preview": m})
        .toList();
    var subCategoryToShowOnDropDown = widget.subCategoriesToDisplay.map(
      (m) => {
        "value": m.id,
        "preview": m.title,
      },
    ).toList();

    return Column(
      children: [
        AddPostDropDownInput(
          hintText: "Post State",
          items: [...postStateToShowOnDropdown],
          onChanged: (value) => updateStateOnInputChange("state", value),
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostDropDownInput(
          hintText: "Sub Category",
          items: [...subCategoryToShowOnDropDown],
          onChanged: (value) => updateStateOnInputChange("subCategory", value),
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Contact Phone",
          onChanged: (value) => updateStateOnInputChange("contactPhone", value),
        ),
        const SizedBox(
          height: 30,
        ),
        ImagePickerInput(
            hintText: "Images",
            onImagePicked: (value) {
              print(value.toString());
            }),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            CancelButton(onTap: widget.onCancel),
            NextOrPostButton(
              isThereAdditionalData: widget.isThereAdditionalData,
              onTap: () {
                widget.onPostOrNext(secondInputValues);
              },
            )
          ],
        )
      ],
    );
  }
}
