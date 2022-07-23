import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/enitites/main_category.dart';
import '../edit_post/post_images.dart';
import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'cancel_button.dart';
import 'input_image_picker.dart';
import 'next_or_post_button.dart';

class SecondPageInputs extends StatefulWidget {
  final Map<String, dynamic> initialValue;
  final Function onCancel;
  final List<String> cities;
  final Function onPost;
  final List<RequiredMainCategoryField> requiredFeilds;

  const SecondPageInputs({
    Key? key,
    required this.onCancel,
    required this.onPost,
    required this.initialValue,
    required this.cities,
    this.requiredFeilds = const [],
  }) : super(key: key);

  @override
  State<SecondPageInputs> createState() => _SecondPageInputsState();
}

class _SecondPageInputsState extends State<SecondPageInputs> {
  List<dynamic> pickedImages = [];
  Map<String, dynamic> otherRequiredFeilds = {};
  String postState = "";
  String brand = "";
  String city = "";

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    postState = widget.initialValue["state"] ?? "";
    city = widget.initialValue["city"] ?? "";
    brand = widget.initialValue["brand"] ?? "";
    pickedImages = [
      ...widget.initialValue["productImages"] ?? [],
    ];
  }

  @override
  Widget build(BuildContext context) {
    var cityToShowOnDropDown =
        widget.cities.map((m) => {"value": m, "preview": m}).toList();
    return Form(
      key: formKey,
      child: Column(
        children: [
          renderPickedImages(),
          const SizedBox(
            height: 30,
          ),
          ImagePickerInput(
            hintText:
                AppLocalizations.of(context).commonPickImagesInputHintText,
            onImagePicked: (value) {
              setState(() {
                if (pickedImages.length + value.length <= 3) {
                  pickedImages = [...pickedImages, ...value];
                }
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          AddPostDropDownInput(
            initialValue: city,
            hintText: AppLocalizations.of(context).commonCityInputHintText,
            items: [...cityToShowOnDropDown],
            onChanged: (value) => city = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).commonCityInputHintText;
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          renderRequiredFields(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CancelButton(onTap: widget.onCancel),
              PostButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    var secondInputValues = buildSecondPageInputs();
                    widget.onPost(secondInputValues);
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  renderPickedImages() {
    return PostImages(
      pickedImages: pickedImages,
      imagesAlreadyInProduct: const [],
      onStateChange: (updatedPostImages, updatedPickedImages) {
        setState(() {
          pickedImages = [...updatedPickedImages];
        });
      },
    );
  }

  buildSecondPageInputs() {
    return {
      "state": postState,
      "city": city,
      "brand": brand,
      "productImages": pickedImages,
      "productDetail": {...otherRequiredFeilds},
    };
  }

  renderRequiredFields() {
    return Column(
      children: [
        ...buildRequiredFeildsInput(),
      ],
    );
  }

  List<Widget> buildRequiredFeildsInput() {
    return widget.requiredFeilds.map((e) {
      if (e.isDropDown) {
        return Column(
          children: [
            AddPostDropDownInput(
              initialValue: "",
              hintText: e.objectKey,
              items: [
                ...e.dropDownValues
                    .map((m) => {"value": m, "preview": m})
                    .toList()
              ],
              onChanged: (value) {
                handleRequiredFeildChanged(e.objectKey, value);
              },
              validator: (value) {
                return validateRequiredFeild(e.objectKey, value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      } else {
        return Column(
          children: [
            AddPostInput(
              hintText: e.objectKey,
              onChanged: (value) {
                handleRequiredFeildChanged(e.objectKey, value);
              },
              validator: (value) {
                return validateRequiredFeild(e.objectKey, value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }
    }).toList();
  }

  handleRequiredFeildChanged(String objectKey, String? value) {
    setState(() {
      otherRequiredFeilds[objectKey] = value;
    });
  }

  validateRequiredFeild(String objectKey, String? value) {
    if (value == null || value.isEmpty) {
      return "Please Select" + objectKey;
    }
    return null;
  }
}
