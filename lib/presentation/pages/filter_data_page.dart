import 'package:flutter/material.dart';

import '../../domain/enitites/main_category.dart';
import '../../domain/enitites/sub_category.dart';
import '../screen_arguments/filter_page_argument.dart';
import '../widgets/add_post/add_post_dropdown_dart.dart';
import '../widgets/common/curved_button.dart';
import '../widgets/filter/filter_by_price.dart';
import '../widgets/filter/filter_categories.dart';
import '../widgets/filter/sort_value_picker.dart';

class FilterDataPage extends StatefulWidget {
  static String routeName = '/filterDataPage';
  const FilterDataPage({Key? key}) : super(key: key);

  @override
  State<FilterDataPage> createState() => _FilterDataPageState();
}

class _FilterDataPageState extends State<FilterDataPage> {
  var _currentPriceRangeValues = const RangeValues(0, 0);
  MainCategory? selectedMainCategory;
  SubCategory? selectedSubCategory;
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    _currentPriceRangeValues = const RangeValues(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as FilterPageArgument;
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      appBar: AppBar(
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffF1F1F1),
        elevation: 1,
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                FilterByPrice(
                  maxValue: args.maxValue,
                  minValue: args.minValue,
                  onChanged: (value) {
                    setState(() {
                      _currentPriceRangeValues = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                renderMainCategories(args),
                const SizedBox(height: 20),
                renderSubCategories(args),
                const SizedBox(height: 20),
                renderBrandDropdown(args),
                const SizedBox(height: 20),
                renderConditionsCheckBoxWrapper(),
                const SizedBox(height: 20),
                renderFilterButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CurvedButton(
          onPressed: () {},
          text: "Remove Filters",
          halfWidth: true,
          backgroundColor: const Color(0xFF79140D),
        ),
        CurvedButton(
          onPressed: () {
            var filterValues;
            Navigator.pop(context, filterValues);
          },
          text: "Apply Filter",
          halfWidth: true,
        ),
      ],
    );
  }

  FilterCategories renderMainCategories(FilterPageArgument args) {
    return FilterCategories(
      categories: [
        ...args.categories,
      ],
      onSelectedCategoryChanged: (value) {
        setState(() {
          selectedMainCategory = value;
          selectedSubCategory = null;
          selectedBrand = null;
        });
      },
      categoryType: "Main Category",
    );
  }

  Visibility renderSubCategories(FilterPageArgument args) {
    var subCategoriesToDisplay = selectedMainCategory != null
        ? args.categories
            .firstWhere((e) => e.id == selectedMainCategory!.id)
            .subCategories
        : [];
    return Visibility(
      visible: subCategoriesToDisplay.isNotEmpty,
      child: FilterCategories(
        categories: [...subCategoriesToDisplay],
        onSelectedCategoryChanged: (value) {
          setState(() {
            selectedSubCategory = value;
          });
        },
        categoryType: "Sub Category",
      ),
    );
  }

  renderBrandDropdown(FilterPageArgument args) {
    var brandToDisplay = getBrandsForCategory(args.categories);
    return Visibility(
      visible: brandToDisplay != null,
      child: AddPostDropDownInput(
        hintText: "Select A Brand",
        items: brandToDisplay ?? [],
        onChanged: (value) {
          setState(() {
            selectedBrand = value;
          });
        },
        validator: () {},
      ),
    );
  }

  List<Map<String, String>>? getBrandsForCategory(
      List<MainCategory> categories) {
    if (selectedMainCategory == null) return null;

    var requiredFeildsContainingBrand = categories
        .firstWhere((e) => e.id == selectedMainCategory!.id)
        .requiredFeilds
        .where((element) => element.objectKey == "brand")
        .toList();

    if (requiredFeildsContainingBrand.isEmpty) return null;

    var brandToDisplay = requiredFeildsContainingBrand.first.dropDownValues
        .map((m) => {"value": m, "preview": m})
        .toList();

    return brandToDisplay;
  }

  renderConditionsCheckBoxWrapper() {
    return Column(
      children: [
        SortValuePicker(
          sortingCriteriaTitle: "Price",
          onSortingCriteriaChanged: (value) {},
        ),
        SortValuePicker(
          sortingCriteriaTitle: "Date of Post",
          onSortingCriteriaChanged: (value) {},
        ),
      ],
    );
  }
}
