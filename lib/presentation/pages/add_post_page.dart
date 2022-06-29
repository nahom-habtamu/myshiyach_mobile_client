import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/models/product/add_product_model.dart';
import '../../domain/enitites/main_category.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/create_product/create_product_cubit.dart';
import '../bloc/create_product/create_product_state.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_state.dart';
import '../widgets/add_post/first_page_inputs.dart';
import '../widgets/add_post/second_page_inputs.dart';
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
    emptyAddPostState();
    initializeCurrentUser();
    initCategories();
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
    var getAllNeededToManagePostCubit =
        context.read<GetDataNeededToManagePostCubit>();
    if (getAllNeededToManagePostCubit.state is! Loaded) {
      getAllNeededToManagePostCubit.call();
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
        body: BlocBuilder<GetDataNeededToManagePostCubit,
            GetDataNeededToManagePostState>(
          builder: (context, state) {
            if (state is Loaded) {
              return renderMainContent(
                state.categories,
                state.cities,
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
                child: Text("EMPTY CATEGORIES"),
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
  ) {
    return BlocBuilder<CreateProductCubit, CreateProductState>(
        builder: (context, state) {
      if (state is AddPostError) {
        Fluttertoast.showToast(
          msg: state.message,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFFA70606),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      if (state is AddPostEmpty) {
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                renderAppropriateInput(
                  categories,
                  cities,
                ),
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
  ) {
    if (currentInputPageState == 0) {
      return renderFirstPageInputs(categories);
    } else if (currentInputPageState == 1) {
      return renderSecondPageInputs(categories, cities);
    }
  }

  renderSecondPageInputs(List<MainCategory> categories, List<String> cities) {
    var requiredFieldsBasedOnSelectedCategory =
        categories.elementAt(selectedMainCategoryIndex).requiredFeilds;

    return SecondPageInputs(
      cities: cities,
      initialValue: mergedInputValues,
      requiredFeilds: requiredFieldsBasedOnSelectedCategory,
      onCancel: () {
        setState(() {
          currentInputPageState--;
        });
      },
      onPost: (secondInputValues) => {onSecondPagePost(secondInputValues)},
    );
  }

  void onSecondPagePost(secondInputValues) {
    appendInputValue(secondInputValues);
    createProduct();
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
  ) {
    return FirstPageInputs(
      initialValue: mergedInputValues,
      mainCategories: categories,
      onNextPressed: (firstInputValues) {
        appendInputValue(firstInputValues);
        setState(() {
          currentInputPageState++;
          selectedMainCategoryIndex = categories.indexWhere(
            (element) => element.id == firstInputValues["mainCategory"],
          );
        });
      },
    );
  }
}
