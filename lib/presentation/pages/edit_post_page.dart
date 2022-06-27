import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product/edit_product_model.dart';
import '../../domain/enitites/main_category.dart';
import '../../domain/enitites/product.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_state.dart';
import '../bloc/update_product/update_product_cubit.dart';
import '../bloc/update_product/update_product_state.dart';
import '../widgets/add_post/add_post_dropdown_dart.dart';
import '../widgets/add_post/add_post_input.dart';
import '../widgets/add_post/input_image_picker.dart';
import '../widgets/common/curved_button.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Post Page',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: product == null ? Container() : renderMainContent(),
      ),
    );
  }

  renderMainContent() {
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
              buildMainCategoriesToDisplay(state.categories);
          var citiesToShowOnDropDown = buildCititesToDisplay(state.cities);
          var subCategoriesToShow = buildSubCategoryToDisplay(state.categories);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    renderPickedImages(),
                    const SizedBox(
                      height: 20,
                    ),
                    ImagePickerInput(
                      hintText: "Pick Post Images",
                      onImagePicked: (value) {
                        setState(() {
                          if (pickedImages.length + value.length <= 3) {
                            pickedImages = [...pickedImages, ...value];
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AddPostInput(
                      hintText: "Title",
                      onChanged: (value) => setState(() => title = value),
                      initialValue: product!.title,
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
                      hintText: "Description",
                      onChanged: (value) => setState(() => description = value),
                      initialValue: product!.description,
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
                      hintText: "Price",
                      onChanged: (value) =>
                          setState(() => price = double.parse(value)),
                      initialValue: product!.price.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Price";
                        } else {
                          try {
                            double.parse(value);
                            return null;
                          } catch (e) {
                            return "Enter Correct Price";
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AddPostDropDownInput(
                      initialValue: mainCategory,
                      items: mainCategoryToShowOnDropDown,
                      hintText: "Category",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Select Main Category";
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
                    const SizedBox(
                      height: 20,
                    ),
                    AddPostDropDownInput(
                      key: Key(subCategory),
                      initialValue: subCategory,
                      items: subCategoriesToShow,
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
                    AddPostDropDownInput(
                      initialValue: city,
                      items: citiesToShowOnDropDown,
                      hintText: "City",
                      onChanged: (value) => setState(() => city = value),
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
                    ...buildRequiredFeildsInput(state.categories),
                    renderSaveButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    renderEditError()
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  List<Widget> buildRequiredFeildsInput(List<MainCategory> categories) {
    var requiredFeilds = categories
        .firstWhere((element) => element.id == mainCategory)
        .requiredFeilds;
    return requiredFeilds.map((e) {
      if (e.isDropDown) {
        return Column(
          children: [
            AddPostDropDownInput(
              initialValue: product!.productDetail![e.objectKey],
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
              initialValue: product!.productDetail![e.objectKey],
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
      productDetail[objectKey] = value;
    });
  }

  validateRequiredFeild(String objectKey, String? value) {
    if (value == null || value.isEmpty) {
      return "Please Select" + objectKey;
    }
    return null;
  }

  renderEditError() {
    return BlocBuilder<UpdateProductCubit, UpdateProductState>(
        builder: (context, state) {
      if (state is EditPostError) {
        return Center(
          child: Text(state.message),
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

      if (state is EditPostSuccessfull) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            PostDetailPage.routeName,
            arguments: state.product,
          );
        });
      }

      return CurvedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            handleUpdatingProduct();
          }
        },
        text: "Save Changes",
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
      List<MainCategory> categories) {
    return categories.map((m) => {"value": m.id, "preview": m.title}).toList();
  }

  List<Map<String, String>> buildCititesToDisplay(List<String> cities) =>
      cities.map((m) => {"value": m, "preview": m}).toList();

  List<Map<String, String>> buildSubCategoryToDisplay(
      List<MainCategory> categories) {
    return mainCategory.isNotEmpty
        ? categories
            .firstWhere((element) => element.id == mainCategory)
            .subCategories
            .map((m) => {"value": m.id, "preview": m.title})
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
