import 'package:flutter/material.dart';

import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';

class FirstPageInputs extends StatelessWidget {
  final List<String> mainCategories;
  const FirstPageInputs({
    Key? key,
    required this.mainCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddPostInput(
          hintText: "Item Title",
        ),
        const SizedBox(
          height: 30,
        ),
        const AddPostInput(
          hintText: "Description",
        ),
        const SizedBox(
          height: 30,
        ),
        const AddPostInput(
          hintText: "Price",
        ),
        const SizedBox(
          height: 30,
        ),
        const AddPostInput(
          hintText: "Quantity",
        ),
        const SizedBox(
          height: 30,
        ),
        AddPostDropDownInput(
          hintText: "Category",
          items: [...mainCategories],
          onChanged: (value) {
            // var indexOfCurrentlySelectedMainCategory =
            //     mainCategories.indexOf(value);
            // setState(() {
            //   selectedMainCategoryIndex = indexOfCurrentlySelectedMainCategory;
            // });
          },
        ),
      ],
    );
  }
}
