import 'package:flutter/material.dart';

import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'next_or_post_button.dart';
import '../../../domain/enitites/main_category.dart';

class FirstPageInputs extends StatefulWidget {
  final Function onNextPressed;
  final List<MainCategory> mainCategories;
  final List<String> cities;
  final Map<String, dynamic> initialValue;
  const FirstPageInputs({
    Key? key,
    required this.mainCategories,
    required this.onNextPressed,
    required this.cities,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<FirstPageInputs> createState() => _FirstPageInputsState();
}

class _FirstPageInputsState extends State<FirstPageInputs> {
  String title = "";
  String description = "";
  double price = 0.0;
  String brand = "";
  String mainCategory = "";
  String city = "";

  @override
  void initState() {
    super.initState();
    title = widget.initialValue["title"] ?? "";
    description = widget.initialValue["description"] ?? "";
    price = widget.initialValue["price"] ?? 0;
    brand = widget.initialValue["brand"] ?? "";
    mainCategory = widget.initialValue["mainCategory"] ?? "";
    city = widget.initialValue["city"] ?? "";
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
          initialValue: title,
          hintText: "Item Title",
          onChanged: (value) => title = value,
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostInput(
          initialValue: description,
          hintText: "Description",
          onChanged: (value) => description = value,
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostInput(
          initialValue: price == 0.0 ? "" : price.toString(),
          hintText: "Price",
          onChanged: (value) => price = double.parse(value),
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostInput(
          initialValue: brand,
          hintText: "Brand",
          onChanged: (value) => brand = value,
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostDropDownInput(
          initialValue: mainCategory,
          hintText: "Category",
          items: [...mainCategoryToShowOnDropDown],
          onChanged: (value) => mainCategory = value,
        ),
        const SizedBox(
          height: 23,
        ),
        AddPostDropDownInput(
          initialValue: city,
          hintText: "City",
          items: [...cityToShowOnDropDown],
          onChanged: (value) => city = value,
        ),
        const SizedBox(
          height: 23,
        ),
        NextOrPostButton(
          isThereAdditionalData: true,
          onTap: () {
            Map<String, dynamic> firstPageInputs = buildFirstPageInputValues();
            widget.onNextPressed(firstPageInputs);
          },
        )
      ],
    );
  }

  Map<String, dynamic> buildFirstPageInputValues() {
    return {
      "title": title,
      "description": description,
      "price": price,
      "brand": brand,
      "mainCategory": mainCategory,
      "city": city,
    };
  }
}
