import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/main_category.dart';
import '../../domain/enitites/product.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_state.dart';
import '../widgets/add_post/add_post_dropdown_dart.dart';
import '../widgets/add_post/add_post_input.dart';
import '../widgets/add_post/input_image_picker.dart';
import '../widgets/edit_post/post_images.dart';

class EditPostPage extends StatefulWidget {
  static String routeName = '/editPostPage';
  const EditPostPage({Key? key}) : super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  List<dynamic> pickedImages = [];
  List<dynamic> imagesAlreadyInProduct = [];
  Product? product;

  String title = "";
  String description = "";
  double price = 0.0;
  String mainCategory = "";
  String subCategory = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initCategories();
      setState(() {
        product = ModalRoute.of(context)!.settings.arguments as Product;
        imagesAlreadyInProduct = [...product!.productImages];
      });
    });
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
                        pickedImages = [...value];
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                    hintText: "Title",
                    onChanged: (value) => {},
                    initialValue: product!.title,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                      hintText: "Description",
                      onChanged: (value) => {},
                      initialValue: product!.description),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                      hintText: "Price",
                      onChanged: (value) => {},
                      initialValue: product!.price.toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                      hintText: "State",
                      onChanged: (value) => {},
                      initialValue: product!.state),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                      hintText: "Brand",
                      onChanged: (value) => {},
                      initialValue: product!.brand),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    items: mainCategoryToShowOnDropDown,
                    hintText: "Category",
                    onChanged: (value) => setState(() => mainCategory = value),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    items: subCategoriesToShow,
                    hintText: "Sub Category",
                    onChanged: (value) => {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    items: citiesToShowOnDropDown,
                    hintText: "City",
                    onChanged: (value) => {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff11435E),
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
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
