import 'package:flutter/material.dart';

import '../../../core/utils/price_formatter.dart';
import '../../../domain/enitites/main_category.dart';
import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'next_or_post_button.dart';

class FirstPageInputs extends StatefulWidget {
  final Function onNextPressed;
  final List<MainCategory> mainCategories;
  final Map<String, dynamic> initialValue;
  const FirstPageInputs({
    Key? key,
    required this.mainCategories,
    required this.onNextPressed,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<FirstPageInputs> createState() => _FirstPageInputsState();
}

class _FirstPageInputsState extends State<FirstPageInputs> {
  String title = "";
  String description = "";
  double price = 0.0;
  String subCategory = "";
  String mainCategory = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    title = widget.initialValue["title"] ?? "";
    description = widget.initialValue["description"] ?? "";
    price = widget.initialValue["price"] ?? 0;
    subCategory = widget.initialValue["subCategory"] ?? "";
    mainCategory = widget.initialValue["mainCategory"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var mainCategoryToShowOnDropDown = buildMainCategoriesToDisplay();
    var subCategoryToShowOnDropDown = buildSubCategoriesToDisplay();
    return Form(
      key: formKey,
      child: Column(
        children: [
          AddPostDropDownInput(
            initialValue: mainCategory,
            hintText: "Category",
            items: [...mainCategoryToShowOnDropDown],
            onChanged: (value) {
              setState(() {
                mainCategory = value;
                subCategory = "";
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Select Main Category";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          AddPostDropDownInput(
            key: Key(subCategory),
            initialValue: subCategory,
            items: subCategoryToShowOnDropDown,
            hintText: "Sub Category",
            onChanged: (value) => setState(
              () => subCategory = value,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Select Sub Category";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          AddPostInput(
            initialValue: title,
            hintText: "Item Title",
            sizeLimit: 30,
            onChanged: (value) => title = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Title";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          AddPostInput(
            initialValue: description,
            hintText: "Description",
            onChanged: (value) => description = value,
            isTextArea: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Description";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          AddPostInput(
            initialValue: price == 0.0 ? "" : price.toString(),
            hintText: "Price",
            onChanged: (value) => price = double.parse(
              PriceFormatterUtil.deformatToPureNumber(value),
            ),
            sizeLimit: 12,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Price";
              } else {
                try {
                  double.parse(
                    PriceFormatterUtil.deformatToPureNumber(value),
                  );
                  return null;
                } catch (e) {
                  return "Enter Correct Price";
                }
              }
            },
            isPrice: true,
          ),
          const SizedBox(
            height: 20,
          ),
          PostButton(
            isPost: false,
            onTap: () {
              if (formKey.currentState!.validate()) {
                Map<String, dynamic> firstPageInputs =
                    buildFirstPageInputValues();
                widget.onNextPressed(firstPageInputs);
              }
            },
          )
        ],
      ),
    );
  }

  List<Map<String, String>> buildMainCategoriesToDisplay() {
    return widget.mainCategories
        .map((m) => {"value": m.id, "preview": m.title})
        .toList();
  }

  List<Map<String, String>> buildSubCategoriesToDisplay() {
    return mainCategory.isNotEmpty
        ? widget.mainCategories
            .firstWhere((element) => element.id == mainCategory)
            .subCategories
            .map((m) => {"value": m.id, "preview": m.title})
            .toList()
        : [];
  }

  Map<String, dynamic> buildFirstPageInputValues() {
    return {
      "title": title,
      "description": description,
      "price": price,
      "subCategory": subCategory,
      "mainCategory": mainCategory,
    };
  }
}
