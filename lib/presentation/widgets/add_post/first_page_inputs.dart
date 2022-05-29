import 'package:flutter/material.dart';

import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'next_or_post_button.dart';
import '../../../domain/enitites/main_category.dart';

class FirstPageInputs extends StatefulWidget {
  final Function onNextPressed;
  final List<MainCategory> mainCategories;
  const FirstPageInputs({
    Key? key,
    required this.mainCategories,
    required this.onNextPressed,
  }) : super(key: key);

  @override
  State<FirstPageInputs> createState() => _FirstPageInputsState();
}

class _FirstPageInputsState extends State<FirstPageInputs> {
  Map<String, dynamic> firstInputValues = {};

  updateStateOnInputChange(String inputKey, String inputValue) {
    setState(() {
      firstInputValues = {...firstInputValues, inputKey: inputValue};
    });
  }

  @override
  Widget build(BuildContext context) {
    var mainCategoryToShowOnDropDown = widget.mainCategories.map(
      (m) => {
        "value": m.id,
        "preview": m.title,
      },
    ).toList();
    return Column(
      children: [
        AddPostInput(
          hintText: "Item Title",
          onChanged: (value) => updateStateOnInputChange("title", value),
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Description",
          onChanged: (value) => updateStateOnInputChange("description", value),
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Price",
          onChanged: (value) => updateStateOnInputChange("price", value),
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostInput(
          hintText: "Brand",
          onChanged: (value) => updateStateOnInputChange("brand", value),
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostDropDownInput(
          hintText: "Category",
          items: [...mainCategoryToShowOnDropDown],
          onChanged: (value) => updateStateOnInputChange("mainCategory", value),
        ),
        const SizedBox(
          height: 30,
        ),
        NextOrPostButton(
          isThereAdditionalData: true,
          onTap: () {
            widget.onNextPressed(firstInputValues);
          },
        )
      ],
    );
  }
}
