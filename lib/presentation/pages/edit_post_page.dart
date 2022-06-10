import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/presentation/widgets/common/curved_button.dart';

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
  String brand = "";
  String city = "";
  String postState = "";

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
        brand = product!.brand;
        city = product!.city;
        postState = product!.state;
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
        body: renderMainContent(),
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
          var postStateToShowOnDropdown = ["New", "Old", "Slightly Used"]
              .map((m) => {"value": m, "preview": m})
              .toList();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                    hintText: "Description",
                    onChanged: (value) => setState(() => description = value),
                    initialValue: product!.description,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                    hintText: "Price",
                    onChanged: (value) =>
                        setState(() => price = double.parse(value)),
                    initialValue: product!.price.toString(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                    hintText: "Brand",
                    onChanged: (value) => setState(() => brand = value),
                    initialValue: product!.brand,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    initialValue: postState,
                    items: postStateToShowOnDropdown,
                    hintText: "State",
                    onChanged: (value) => setState(
                      () => postState = value,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    initialValue: mainCategory,
                    items: mainCategoryToShowOnDropDown,
                    hintText: "Category",
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    initialValue: city,
                    items: citiesToShowOnDropDown,
                    hintText: "City",
                    onChanged: (value) => setState(() => city = value),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  renderSaveButton()
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
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
          handleUpdatingProduct();
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
      brand: brand,
      city: city,
      description: description,
      mainCategory: mainCategory,
      subCategory: subCategory,
      price: price,
      productImages: [],
      state: postState,
      title: title,
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
