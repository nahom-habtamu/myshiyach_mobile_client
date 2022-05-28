import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/get_categories/get_categories_state.dart';
import '../../domain/enitites/main_category.dart';
import '../bloc/get_categories/get_categories_cubit.dart';
import '../widgets/add_post/cancel_button.dart';
import '../widgets/add_post/first_page_inputs.dart';
import '../widgets/add_post/next_or_post_button.dart';
import '../widgets/add_post/add_post_input.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<GetAllCategoriesCubit>().call();
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

  SingleChildScrollView renderMainContent(
      List<MainCategory> categories, bool isThereAdditionalData) {
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
            renderAppropriateInput(categories),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentInputPageState != 0)
                    CancelButton(onTap: () {
                      setState(() {
                        currentInputPageState--;
                      });
                    }),
                  NextOrPostButton(
                    currentInputPageState: currentInputPageState,
                    isThereAdditionalData: isThereAdditionalData,
                    onTap: (i) {
                      setState(() {
                        currentInputPageState = i;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  renderAppropriateInput(List<MainCategory> categories) {
    if (currentInputPageState == 0) {
      return renderFirstPageInputs(categories);
    } else if (currentInputPageState == 1) {
      return renderSecondPageInputs(categories);
    } else if (isThereThirdInputList(categories) &&
        currentInputPageState == 2) {
      return renderThirdPageInputs(categories);
    }
  }

  Column renderThirdPageInputs(List<MainCategory> categories) {
    var additionalInputs = categories[selectedMainCategoryIndex]
        .subCategories[0]
        .additionalData
        .map((e) => AddPostInput(hintText: e));
    return Column(
      children: [...additionalInputs],
    );
  }

  bool isThereThirdInputList(List<MainCategory> categories) {
    return categories[selectedMainCategoryIndex]
        .subCategories[0]
        .additionalData
        .isNotEmpty;
  }

  renderSecondPageInputs(List<MainCategory> categories) {
    var subCategoriesToDisplay = categories
        .elementAt(selectedMainCategoryIndex)
        .subCategories
        .map((e) => e.title)
        .toList();
    return SecondPageInputs(subCategoriesToDisplay: subCategoriesToDisplay);
  }

  renderFirstPageInputs(List<MainCategory> categories) {
    var mainCategories = categories.map((c) => c.title).toList();
    return FirstPageInputs(mainCategories: mainCategories);
  }
}