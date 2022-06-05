import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product/add_product_model.dart';
import '../../domain/enitites/main_category.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/create_product/create_product_cubit.dart';
import '../bloc/create_product/create_product_state.dart';
import '../bloc/get_data_needed_to_add_post/get_data_needed_to_add_post_cubit.dart';
import '../bloc/get_data_needed_to_add_post/get_data_needed_to_add_post_state.dart';
import '../widgets/add_post/first_page_inputs.dart';
import '../widgets/add_post/second_page_inputs.dart';
import '../widgets/add_post/third_page_inputs.dart';
import 'post_confirmation_page.dart';

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
  String accessToken = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initializeCurrentUser();
      initCategories();
      emptyAddPostState();
    });
  }

  void emptyAddPostState() {
    context.read<CreateProductCubit>().clear();
  }

  void initializeCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
    }
  }

  void initCategories() {
    var getAllCategoriesCubit = context.read<GetDataNeededToAddPostCubit>();
    if (getAllCategoriesCubit.state is! Loaded) {
      getAllCategoriesCubit.call();
    }
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
        body: BlocBuilder<GetDataNeededToAddPostCubit,
            GetDataNeededToAddPostState>(
          builder: (context, state) {
            if (state is Loaded) {
              var isThereAdditionalData =
                  isThereThirdInputList(state.categories);
              return renderMainContent(
                state.categories,
                state.cities,
                isThereAdditionalData,
              );
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

  renderMainContent(
    List<MainCategory> categories,
    List<String> cities,
    bool isThereAdditionalData,
  ) {
    return BlocBuilder<CreateProductCubit, CreateProductState>(
        builder: (context, state) {
      if (state is AddPostEmpty || state is AddPostError) {
        return SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(top: 0, left: 25, right: 25),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                renderAppropriateInput(
                    categories, cities, isThereAdditionalData),
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
    List<MainCategory> categories,
    List<String> cities,
    bool isThereAdditionalData,
  ) {
    if (currentInputPageState == 0) {
      return renderFirstPageInputs(categories, cities);
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
          accessToken,
        );
  }

  renderFirstPageInputs(
    List<MainCategory> categories,
    List<String> cities,
  ) {
    return FirstPageInputs(
      mainCategories: categories,
      cities: cities,
      onNextPressed: (firstInputValues) {
        appendInputValue(firstInputValues);
        setState(() {
          currentInputPageState++;
        });
      },
    );
  }
}
