import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/price_formatter.dart';
import '../../data/models/product/edit_product_model.dart';
import '../../domain/enitites/main_category.dart';
import '../../domain/enitites/product.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/change_language/change_language_cubit.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_state.dart';
import '../bloc/update_product/update_product_cubit.dart';
import '../bloc/update_product/update_product_state.dart';
import '../screen_arguments/post_detail_page_arguments.dart';
import '../utils/show_toast.dart';
import '../widgets/add_post/add_post_dropdown_dart.dart';
import '../widgets/add_post/add_post_input.dart';
import '../widgets/add_post/input_image_picker.dart';
import '../widgets/common/action_button.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/edit_post/post_images.dart';
import 'post_detail_page.dart';

class EditPostPage extends StatefulWidget {
  static String routeName = '/editPostPage';
  const EditPostPage({Key? key}) : super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  String accessToken = "";
  List<dynamic> pickedImages = [];
  List<dynamic> imagesAlreadyInProduct = [];
  Product? product;

  String title = "";
  String description = "";
  double price = 0.0;
  String mainCategory = "";
  String subCategory = "";
  String city = "";
  String contactPhone = "";
  Map<String, dynamic> productDetail = {};

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initializeCurrentUser();
      initCategories();
      context.read<UpdateProductCubit>().clear();
      setState(() {
        product = ModalRoute.of(context)!.settings.arguments as Product;
        imagesAlreadyInProduct = [...product!.productImages];
        title = product!.title;
        description = product!.description;
        price = product!.price;
        mainCategory = product!.mainCategory;
        subCategory = product!.subCategory;
        city = product!.city;
        contactPhone = product!.contactPhone;
      });
    });
  }

  void initializeCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
    }
  }

  void initCategories() {
    var getAllNeededToManagePostCubit =
        context.read<GetDataNeededToManagePostCubit>();
    if (getAllNeededToManagePostCubit.state is! Loaded) {
      getAllNeededToManagePostCubit.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).editPostAppBarText,
      ),
      body: product != null
          ? BlocBuilder<ChangeLanguageCubit, String>(builder: (context, state) {
              return CurvedContainer(
                child: renderMainContent(state),
              );
            })
          : Container(),
    );
  }

  renderMainContent(String language) {
    return BlocBuilder<GetDataNeededToManagePostCubit,
        GetDataNeededToManagePostState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is Loaded) {
          var mainCategoryToShowOnDropDown =
              buildMainCategoriesToDisplay(state.categories, language);
          var citiesToShowOnDropDown =
              buildCititesToDisplay(state.cities, language);
          var subCategoriesToShow =
              buildSubCategoryToDisplay(state.categories, language);

          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  renderPickedImages(),
                  const SizedBox(height: 20),
                  ImagePickerInput(
                    hintText: AppLocalizations.of(context)
                        .commonPickImagesInputHintText,
                    onImagePicked: (value) {
                      setState(() {
                        if (pickedImages.length + value.length <= 3) {
                          pickedImages = [...pickedImages, ...value];
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  AddPostInput(
                    hintText:
                        AppLocalizations.of(context).commonTitleInputHintText,
                    sizeLimit: 30,
                    onChanged: (value) => setState(() => title = value),
                    initialValue: product!.title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .commonTitleInputEmptyText;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AddPostInput(
                    hintText: AppLocalizations.of(context)
                        .commonDescriptionInputHintText,
                    isTextArea: true,
                    onChanged: (value) => setState(() => description = value),
                    initialValue: product!.description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .commonDescriptionInputEmptyText;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AddPostInput(
                    hintText: AppLocalizations.of(context)
                        .commonContactPersonInputHintText,
                    onChanged: (value) => setState(() => contactPhone = value),
                    initialValue: product!.contactPhone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .commonContactPersonInputHintText;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AddPostInput(
                    hintText:
                        AppLocalizations.of(context).commonPriceInputHintText,
                    sizeLimit: 13,
                    isPrice: true,
                    onChanged: (value) => setState(
                      () => price = double.parse(
                        PriceFormatterUtil.deformatToPureNumber(value),
                      ),
                    ),
                    initialValue:
                        PriceFormatterUtil.formatToPrice(product!.price),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .commonPriceInputEmptyText;
                      } else {
                        try {
                          double.parse(
                              PriceFormatterUtil.deformatToPureNumber(value));
                          return null;
                        } catch (e) {
                          return AppLocalizations.of(context)
                              .commonPriceInputIncorrectError;
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  AddPostDropDownInput(
                    initialValue: mainCategory,
                    items: mainCategoryToShowOnDropDown,
                    hintText: AppLocalizations.of(context)
                        .commonMainCategoryInputHintText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .commonMainCategoryInputEmptyText;
                      }
                      return null;
                    },
                    onChanged: (value) => setState(
                      () {
                        mainCategory = value;
                        subCategory = "";
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  AddPostDropDownInput(
                    key: Key(subCategory),
                    initialValue: subCategory,
                    items: subCategoriesToShow,
                    hintText: AppLocalizations.of(context)
                        .commonSubCategoryInputHintText,
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
                  const SizedBox(height: 20),
                  AddPostDropDownInput(
                    initialValue: city,
                    items: citiesToShowOnDropDown,
                    hintText:
                        AppLocalizations.of(context).commonCityInputHintText,
                    onChanged: (value) => setState(() => city = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .commonCityInputEmptyText;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ...buildRequiredFeildsInput(state.categories, language),
                  renderSaveButton(),
                  const SizedBox(height: 20),
                  renderEditError()
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  List<Widget> buildRequiredFeildsInput(
    List<MainCategory> categories,
    String language,
  ) {
    var requiredFeilds = categories
        .firstWhere((element) => element.id == mainCategory)
        .requiredFeilds;
    return requiredFeilds.map((e) {
      if (e.isDropDown) {
        return Column(
          children: [
            AddPostDropDownInput(
              initialValue: product?.productDetail?[e.objectKey] ?? "",
              hintText: language == "en"
                  ? e.title.split(";").first
                  : e.title.split(";").last,
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
                handleRequiredFeildChanged(e.objectKey, value);
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
              initialValue: product!.productDetail?[e.objectKey] ?? '',
              hintText: language == "en"
                  ? e.title.split(";").first
                  : e.title.split(";").last,
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
      productDetail[objectKey] = value;
    });
  }

  validateRequiredFeild(String title, String? value) {
    if (value == null || value.isEmpty) {
      return "Please Select" + title;
    }
    return null;
  }

  renderEditError() {
    return BlocBuilder<UpdateProductCubit, UpdateProductState>(
        builder: (context, state) {
      if (state is EditPostError) {
        return Center(
          child: Text(AppLocalizations.of(context).editPostError),
        );
      }
      return Container();
    });
  }

  renderSaveButton() {
    return BlocBuilder<UpdateProductCubit, UpdateProductState>(
        builder: (context, state) {
      if (state is EditPostLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is EditPostNoNetwork) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          showToast(context, "Please Connect To Network");
        });
      }
      if (state is EditPostSuccessfull) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            PostDetailPage.routeName,
            arguments: PostDetalPageArguments(
              isFromDynamicLink: false,
              product: state.product,
            ),
          );
        });
      }

      return ActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            handleUpdatingProduct();
          }
        },
        text: AppLocalizations.of(context).editPostSaveButtonText,
      );
    });
  }

  void handleUpdatingProduct() {
    var productId = product!.id;
    var imagesToUpload = [...pickedImages];
    var productImages = [...imagesAlreadyInProduct];
    var editProductModel = EditProductModel(
      city: city,
      description: description,
      mainCategory: mainCategory,
      subCategory: subCategory,
      price: price,
      contactPhone: contactPhone,
      productImages: [],
      title: title,
      productDetail: productDetail,
    );

    context.read<UpdateProductCubit>().call(
          productId,
          editProductModel,
          imagesToUpload,
          productImages,
          accessToken,
        );
  }

  String getSubCategoryInitialValue(List<MainCategory> categories) {
    var currentMainCategory =
        categories.firstWhere((element) => element.id == mainCategory);

    var subCategoriesWithCurrentMainCat = currentMainCategory.subCategories
        .where((element) => element.id == subCategory)
        .toList();

    if (subCategoriesWithCurrentMainCat.isNotEmpty) {
      return subCategory;
    }

    return "";
  }

  List<Map<String, String>> buildMainCategoriesToDisplay(
    List<MainCategory> categories,
    String language,
  ) {
    return categories
        .map((m) => {
              "value": m.id,
              "preview": language == "en"
                  ? m.title.split(';').first
                  : m.title.split(';').last
            })
        .toList();
  }

  List<Map<String, String>> buildCititesToDisplay(
    List<String> cities,
    String language,
  ) =>
      cities
          .map((m) => {
                "value": m,
                "preview":
                    language == "en" ? m.split(';').first : m.split(';').last
              })
          .toList();

  List<Map<String, String>> buildSubCategoryToDisplay(
    List<MainCategory> categories,
    String language,
  ) {
    return mainCategory.isNotEmpty
        ? categories
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

  renderPickedImages() {
    return PostImages(
      pickedImages: pickedImages,
      imagesAlreadyInProduct: imagesAlreadyInProduct,
      onStateChange: (updatedPostImages, updatedPickedImages) {
        setState(() {
          imagesAlreadyInProduct = [...updatedPostImages];
          pickedImages = [...updatedPickedImages];
        });
      },
    );
  }
}
