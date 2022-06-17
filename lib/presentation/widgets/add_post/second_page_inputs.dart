import 'package:flutter/material.dart';

import '../../../domain/enitites/sub_category.dart';
import '../edit_post/post_images.dart';
import 'add_post_dropdown_dart.dart';
import 'cancel_button.dart';
import 'input_image_picker.dart';
import 'next_or_post_button.dart';

class SecondPageInputs extends StatefulWidget {
  final Map<String, dynamic> initalValue;
  final List<SubCategory> subCategoriesToDisplay;
  final Function onCancel;
  final Function onPost;

  const SecondPageInputs({
    Key? key,
    required this.subCategoriesToDisplay,
    required this.onCancel,
    required this.onPost,
    required this.initalValue,
  }) : super(key: key);

  @override
  State<SecondPageInputs> createState() => _SecondPageInputsState();
}

class _SecondPageInputsState extends State<SecondPageInputs> {
  List<dynamic> pickedImages = [];
  String postState = "";
  String subCategory = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    postState = widget.initalValue["state"] ?? "";
    subCategory = widget.initalValue["subCategory"] ?? "";
    pickedImages = [
      ...widget.initalValue["productImages"] ?? [],
    ];
  }

  @override
  Widget build(BuildContext context) {
    var postStateToShowOnDropdown = ["New", "Old", "Slightly Used"]
        .map((m) => {"value": m, "preview": m})
        .toList();
    var subCategoryToShowOnDropDown = widget.subCategoriesToDisplay
        .map(
          (m) => {
            "value": m.id,
            "preview": m.title,
          },
        )
        .toList();

    return Form(
      key: formKey,
      child: Column(
        children: [
          renderPickedImages(),
          const SizedBox(
            height: 30,
          ),
          ImagePickerInput(
            hintText: "Images",
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
            initialValue: postState,
            hintText: "Post State",
            items: [...postStateToShowOnDropdown],
            onChanged: (value) => postState = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Select Post State";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          AddPostDropDownInput(
            initialValue: subCategory,
            hintText: "Sub Category",
            items: [...subCategoryToShowOnDropDown],
            onChanged: (value) => subCategory = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Select Sub Category";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
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
      "subCategory": subCategory,
      "productImages": pickedImages,
    };
  }
}
