import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mnale_client/presentation/bloc/change_language/change_language_cubit.dart';

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
  final desciptionFocusNode = FocusNode();

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
  void dispose() {
    super.dispose();
    desciptionFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeLanguageCubit, String>(builder: (context, state) {
      return Form(
        key: formKey,
        child: Column(
          children: [
            AddPostDropDownInput(
              initialValue: mainCategory,
              hintText:
                  AppLocalizations.of(context).commonMainCategoryInputHintText,
              items: buildMainCategoriesToDisplay(state),
              onChanged: (value) {
                setState(() {
                  mainCategory = value;
                  subCategory = "";
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .commonMainCategoryInputEmptyText;
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
              items: buildSubCategoriesToDisplay(state),
              hintText:
                  AppLocalizations.of(context).commonSubCategoryInputHintText,
              onChanged: (value) => setState(
                () => subCategory = value,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .commonSubCategoryInputEmptyText;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            AddPostInput(
              onSubmitted: (_) => desciptionFocusNode.requestFocus(),
              initialValue: title,
              hintText: AppLocalizations.of(context).commonTitleInputHintText,
              sizeLimit: 30,
              onChanged: (value) => title = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).commonTitleInputEmptyText;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            AddPostInput(
              focusNode: desciptionFocusNode,
              initialValue: description,
              hintText:
                  AppLocalizations.of(context).commonDescriptionInputHintText,
              onChanged: (value) => description = value,
              isTextArea: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .commonDescriptionInputHintText;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            AddPostInput(
              onSubmitted: (_) => handleGoingToNextInputs(),
              initialValue: price == 0.0 ? "" : price.toString(),
              hintText: AppLocalizations.of(context).commonPriceInputHintText,
              onChanged: (value) => price = double.parse(
                PriceFormatterUtil.deformatToPureNumber(value),
              ),
              sizeLimit: 13,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).commonPriceInputHintText;
                } else {
                  try {
                    double.parse(
                      PriceFormatterUtil.deformatToPureNumber(value),
                    );
                    return null;
                  } catch (e) {
                    return AppLocalizations.of(context)
                        .commonPriceInputIncorrectError;
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
                handleGoingToNextInputs();
              },
            )
          ],
        ),
      );
    });
  }

  void handleGoingToNextInputs() {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> firstPageInputs = buildFirstPageInputValues();
      widget.onNextPressed(firstPageInputs);
    }
  }

  List<Map<String, String>> buildMainCategoriesToDisplay(String language) {
    return widget.mainCategories
        .map((m) => {
              "value": m.id,
              "preview": language == "en"
                  ? m.title.split(';').first
                  : m.title.split(';').last
            })
        .toList();
  }

  List<Map<String, String>> buildSubCategoriesToDisplay(String language) {
    return mainCategory.isNotEmpty
        ? widget.mainCategories
            .firstWhere((element) => element.id == mainCategory)
            .subCategories
            .map((m) => {
                  "value": m.id,
                  "preview": language == "en"
                      ? m.title.split(';').first
                      : m.title.split(';').last
                })
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
