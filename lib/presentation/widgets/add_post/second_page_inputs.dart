import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/enitites/main_category.dart';
import '../../bloc/change_language/change_language_cubit.dart';
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
  String contactPhone = "";
  String contactName = "";

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
    contactPhone = widget.initialValue["contactPhone"] ?? "";
    contactName = widget.initialValue["contactName"] ?? "";
  }

  parseCitiesToDisplay(String language) {
    return widget.cities
        .map((m) => {
              "value": m,
              "preview":
                  language == "en" ? m.split(';').first : m.split(';').last
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeLanguageCubit, String>(builder: (context, state) {
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
              items: parseCitiesToDisplay(state),
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
            AddPostInput(
              initialValue: contactPhone,
              isOnlyNumbers: true,
              hintText:
                  AppLocalizations.of(context).commonContactPersonInputHintText,
              onChanged: (value) => contactPhone = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .commonContactPersonInputHintText;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            AddPostInput(
              initialValue: contactName,
              hintText:
                  AppLocalizations.of(context).commonContactNameInputHintText,
              onChanged: (value) => contactName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .commonContactNameInputHintText;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            renderRequiredFields(state),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CancelButton(onTap: widget.onCancel),
                PostButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      if (pickedImages.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)
                                .addPostNoImageWarning),
                            backgroundColor: Colors.deepOrange,
                          ),
                        );
                        return;
                      } else {
                        var secondInputValues = buildSecondPageInputs();
                        widget.onPost(secondInputValues);
                      }
                    }
                  },
                )
              ],
            )
          ],
        ),
      );
    });
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
      "contactPhone": contactPhone,
      "contactName": contactName,
      "productImages": pickedImages,
      "productDetail": {...otherRequiredFeilds},
    };
  }

  renderRequiredFields(String language) {
    return Column(
      children: [
        ...buildRequiredFeildsInput(language),
      ],
    );
  }

  List<Widget> buildRequiredFeildsInput(String language) {
    return widget.requiredFeilds.map((e) {
      if (e.isDropDown) {
        return Column(
          children: [
            AddPostDropDownInput(
              initialValue: "",
              hintText: language == "en"
                  ? e.title.split(';').first
                  : e.title.split(';').last,
              items: [
                ...e.dropDownValues
                    .map((m) => {
                          "value": m,
                          "preview": language == "en"
                              ? m.split(';').first
                              : m.split(';').last
                        })
                    .toList()
              ],
              onChanged: (value) {
                handleRequiredFeildChanged(e, value);
              },
              validator: (value) {
                return validateRequiredFeild(e.title, value);
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
                handleRequiredFeildChanged(e, value);
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

  handleRequiredFeildChanged(
    RequiredMainCategoryField requiredFeild,
    String? value,
  ) {
    setState(() {
      otherRequiredFeilds[requiredFeild.objectKey] = {
        "title": requiredFeild.title,
        "value": value
      };
    });
  }

  validateRequiredFeild(String title, String? value) {
    if (value == null || value.isEmpty) {
      return "Please Select" + title;
    }
    return null;
  }
}
