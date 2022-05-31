import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_confirmation_page.dart';
import '../../data/models/product/add_product_model.dart';
import '../../domain/enitites/main_category.dart';
import '../bloc/get_categories/get_categories_state.dart';
import '../bloc/create_product/create_product_cubit.dart';
import '../bloc/create_product/create_product_state.dart';
import '../bloc/get_categories/get_categories_cubit.dart';
import '../widgets/add_post/third_page_inputs.dart';
import '../widgets/add_post/first_page_inputs.dart';
import '../widgets/add_post/second_page_inputs.dart';

class AddPostPage extends StatefulWidget {
  static String routeName = "/addPostPage";
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  int currentInputPageState = 0;
  int selectedMainCategoryIndex = 0;
  Map<String, dynamic> mergedInputValues = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<GetAllCategoriesCubit>().call();
    });
  }

  appendInputValue(Map<String, dynamic> inputValues) {
    setState(() {
      mergedInputValues = {...mergedInputValues, ...inputValues};
    });
  }

  addOtherInputValues(Map<String, dynamic> otherInputValues) {
    setState(() {
      mergedInputValues = {...mergedInputValues, "other": otherInputValues};
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        appBar: AppBar(
          title: const Text(
            'Post Information',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<GetAllCategoriesCubit, GetAllCategoriesState>(
          builder: (context, state) {
            if (state is Loaded) {
              var isThereAdditionalData =
                  isThereThirdInputList(state.categories);
              return renderMainContent(state.categories, isThereAdditionalData);
            } else if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Error) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text("EMPTY"),
              );
            }
          },
        ),
      ),
    );
  }

  renderMainContent(List<MainCategory> categories, bool isThereAdditionalData) {
    return BlocBuilder<CreateProductCubit, CreateProductState>(
        builder: (context, state) {
      if (state is AddPostNotTriggered || state is AddPostError) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                renderAppropriateInput(categories, isThereAdditionalData),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        );
      } else if (state is AddPostLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            PostConfirmationPage.routeName,
          );
        });
        return Container();
      }
    });
  }

  renderAppropriateInput(
      List<MainCategory> categories, bool isThereAdditionalData) {
    if (currentInputPageState == 0) {
      return renderFirstPageInputs(categories);
    } else if (currentInputPageState == 1) {
      return renderSecondPageInputs(categories, isThereAdditionalData);
    } else if (isThereThirdInputList(categories) &&
        currentInputPageState == 2) {
      return renderThirdPageInputs(categories);
    }
  }

  renderThirdPageInputs(List<MainCategory> categories) {
    var additionalDataToDisplay =
        categories[selectedMainCategoryIndex].subCategories[0].additionalData;

    return ThirdPageInputs(
      additionalData: additionalDataToDisplay,
      onCancel: () {
        setState(() {
          currentInputPageState--;
        });
      },
      onPost: (thirdInputValues) {
        addOtherInputValues(thirdInputValues);
        createProduct();
      },
    );
  }

  bool isThereThirdInputList(List<MainCategory> categories) {
    return categories[selectedMainCategoryIndex]
        .subCategories[0]
        .additionalData
        .isNotEmpty;
  }

  renderSecondPageInputs(
      List<MainCategory> categories, bool isThereAdditionalData) {
    var subCategoriesToDisplay =
        categories.elementAt(selectedMainCategoryIndex).subCategories.toList();

    return SecondPageInputs(
      isThereAdditionalData: isThereAdditionalData,
      subCategoriesToDisplay: subCategoriesToDisplay,
      onCancel: () {
        setState(() {
          currentInputPageState--;
        });
      },
      onPostOrNext: (secondInputValues) =>
          {onSecondPagePost(secondInputValues, isThereAdditionalData)},
    );
  }

  void onSecondPagePost(secondInputValues, bool isThereAdditionalData) {
    appendInputValue(secondInputValues);
    if (isThereAdditionalData) {
      setState(() {
        currentInputPageState++;
      });
    } else {
      createProduct();
    }
  }

  void createProduct() {
    var productToAdd = AddProductModel.fromJson(mergedInputValues);
    context.read<CreateProductCubit>().call(
      productToAdd,
      mergedInputValues["productImages"],
    );
  }

  renderFirstPageInputs(List<MainCategory> categories) {
    return FirstPageInputs(
      mainCategories: categories,
      onNextPressed: (firstInputValues) {
        appendInputValue(firstInputValues);
        setState(() {
          currentInputPageState++;
        });
      },
    );
  }
}
