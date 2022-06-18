import 'package:flutter/material.dart';

import '../../../domain/enitites/sub_category.dart';
import '../edit_post/post_images.dart';
import 'add_post_dropdown_dart.dart';
import 'add_post_input.dart';
import 'cancel_button.dart';
import 'input_image_picker.dart';
import 'next_or_post_button.dart';

class SecondPageInputs extends StatefulWidget {
  final Map<String, dynamic> initalValue;
  final List<SubCategory> subCategoriesToDisplay;
  final Function onCancel;
  final List<String> cities;
  final Function onPost;

  const SecondPageInputs({
    Key? key,
    required this.subCategoriesToDisplay,
    required this.onCancel,
    required this.onPost,
    required this.initalValue,
    required this.cities,
  }) : super(key: key);

  @override
  State<SecondPageInputs> createState() => _SecondPageInputsState();
}

class _SecondPageInputsState extends State<SecondPageInputs> {
  List<dynamic> pickedImages = [];
  String postState = "";
  String brand = "";
  String city = "";

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    postState = widget.initalValue["state"] ?? "";
    city = widget.initalValue["city"] ?? "";
    brand = widget.initalValue["brand"] ?? "";
    pickedImages = [
      ...widget.initalValue["productImages"] ?? [],
    ];
  }

  @override
  Widget build(BuildContext context) {
    var postStateToShowOnDropdown = ["New", "Old", "Slightly Used"]
        .map((m) => {"value": m, "preview": m})
        .toList();
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
          AddPostInput(
            initialValue: brand,
            hintText: "Brand",
            onChanged: (value) => brand = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Brand";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          AddPostDropDownInput(
            initialValue: city,
            hintText: "City",
            items: [...cityToShowOnDropDown],
            onChanged: (value) => city = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Select City";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
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
      "city": city,
      "brand": brand,
      "productImages": pickedImages,
    };
  }
}
