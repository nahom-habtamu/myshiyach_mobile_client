import 'package:flutter/material.dart';

import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'next_or_post_button.dart';
import '../../../domain/enitites/main_category.dart';

class FirstPageInputs extends StatefulWidget {
  final Function onNextPressed;
  final List<MainCategory> mainCategories;
  final List<String> cities;
  const FirstPageInputs({
    Key? key,
    required this.mainCategories,
    required this.onNextPressed,
    required this.cities,
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
    var mainCategoryToShowOnDropDown = widget.mainCategories
        .map((m) => {"value": m.id, "preview": m.title})
        .toList();
    var cityToShowOnDropDown =
        widget.cities.map((m) => {"value": m, "preview": m}).toList();
    return Column(
      children: [
        AddPostInput(
          hintText: "Item Title",
          onChanged: (value) => updateStateOnInputChange("title", value),
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostInput(
          hintText: "Description",
          onChanged: (value) => updateStateOnInputChange("description", value),
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostInput(
          hintText: "Price",
          onChanged: (value) => updateStateOnInputChange("price", value),
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostInput(
          hintText: "Brand",
          onChanged: (value) => updateStateOnInputChange("brand", value),
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostDropDownInput(
          hintText: "Category",
          items: [...mainCategoryToShowOnDropDown],
          onChanged: (value) => updateStateOnInputChange("mainCategory", value),
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostDropDownInput(
          hintText: "City",
          items: [...cityToShowOnDropDown],
          onChanged: (value) => updateStateOnInputChange("city", value),
        ),
        const SizedBox(
          height: 23,
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
