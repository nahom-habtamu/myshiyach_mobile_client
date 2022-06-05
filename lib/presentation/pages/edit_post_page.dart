import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/product.dart';
import '../bloc/get_all_categories/get_all_categories_cubit.dart';
import '../bloc/get_all_categories/get_all_categories_state.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<GetAllCategoriesCubit>().call();
      setState(() {
        product = ModalRoute.of(context)!.settings.arguments as Product;
        imagesAlreadyInProduct = [...product!.productImages];
      });
    });
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
    
    return BlocBuilder<GetAllCategoriesCubit, GetAllCategoriesState>(
      builder: (context, state) {
        if (state is GetAllCategoriesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetAllCategoriesLoaded) {
              var mainCategoryToShowOnDropDown = state.categories
        .map((m) => {"value": m.id, "preview": m.title})
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostInput(
                    hintText: "Price",
                    onChanged: (value) => {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    items: mainCategoryToShowOnDropDown,
                    hintText: "Category",
                    onChanged: (value) => {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddPostDropDownInput(
                    items: const [],
                    hintText: "Sub Category",
                    onChanged: (value) => {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
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
