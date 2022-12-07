import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/change_language/change_language_cubit.dart';

import '../../data/models/filter/filter_criteria_model.dart';
import '../../domain/enitites/main_category.dart';
import '../../domain/enitites/sub_category.dart';
import '../screen_arguments/filter_page_argument.dart';
import '../widgets/common/action_button.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/filter/filter_drop_down_input.dart';
import '../widgets/filter/price_range_input_dialog.dart';
import '../widgets/filter/sort_value_picker.dart';

class FilterDataPage extends StatefulWidget {
  static String routeName = '/filterDataPage';
  const FilterDataPage({Key? key}) : super(key: key);

  @override
  State<FilterDataPage> createState() => _FilterDataPageState();
}

class _FilterDataPageState extends State<FilterDataPage> {
  FilterPageArgument args = FilterPageArgument.empty();
  double? minPriceFromDialog = 0.0;
  double? maxPriceFromDialog = 0.0;
  MainCategory? selectedMainCategory;
  SubCategory? selectedSubCategory;
  String? selectedBrand;
  String? selectedCity;
  bool? sortByPriceAscending;
  bool? sortByCreatedByAscending;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as FilterPageArgument;
      });
      if (args.initialFilterCriteria != null) {
        initalizeFilterCriteriaHolders();
      }
    });
  }

  void initalizeFilterCriteriaHolders() {
    setState(() {
      minPriceFromDialog = args.initialFilterCriteria!.minPrice;
      maxPriceFromDialog = args.initialFilterCriteria!.maxPrice;
      selectedMainCategory = args.initialFilterCriteria!.mainCategory;
      selectedSubCategory = args.initialFilterCriteria!.subCategory;
      selectedBrand = args.initialFilterCriteria!.brand;
      selectedCity = args.initialFilterCriteria!.city;
      sortByPriceAscending = args.initialFilterCriteria!.sortByPriceAscending;
      sortByCreatedByAscending =
          args.initialFilterCriteria!.sortByCreatedByAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleApplyingFilter();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff11435E),
        appBar: CustomAppBar(
          title: AppLocalizations.of(context).filterAppBarText,
        ),
        body:
            BlocBuilder<ChangeLanguageCubit, String>(builder: (context, state) {
          var brandToDisplay = getBrandsForCategory(args.allCategories, state);

          return CurvedContainer(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PriceRangeInputDialog(
                      key: Key(
                        (minPriceFromDialog! * maxPriceFromDialog!).toString(),
                      ),
                      initialMin: minPriceFromDialog!,
                      initialMax: maxPriceFromDialog!,
                      onChanged: (min, max) {
                        setState(() {
                          minPriceFromDialog = min;
                          maxPriceFromDialog = max;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    renderMainCategories(state),
                    Visibility(
                      child: const SizedBox(height: 20),
                      visible: selectedMainCategory != null,
                    ),
                    renderSubCategories(state),
                    const SizedBox(height: 20),
                    renderCityDropdown(state),
                    const SizedBox(height: 20),
                    renderBrandDropdown(brandToDisplay),
                    Visibility(
                      child: const SizedBox(height: 20),
                      visible: brandToDisplay != null,
                    ),
                    renderConditionsCheckBoxWrapper(),
                    const SizedBox(height: 20),
                    renderFilterButtons(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  renderFilterButtons() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            onPressed: () {
              handleClearingFilter();
            },
            text: AppLocalizations.of(context).filterRemoveButtonText,
            halfWidth: true,
            backgroundColor: Colors.transparent,
          ),
          ActionButton(
            onPressed: () {
              handleApplyingFilter();
            },
            text: AppLocalizations.of(context).filterApplyButtonText,
            halfWidth: true,
          ),
        ],
      ),
    );
  }

  void handleApplyingFilter() {
    var filterValues = FilterCriteriaModel(
      brand: selectedBrand,
      mainCategory: selectedMainCategory,
      subCategory: selectedSubCategory,
      city: selectedCity,
      maxPrice: maxPriceFromDialog,
      minPrice: minPriceFromDialog,
      sortByCreatedByAscending: sortByCreatedByAscending,
      sortByPriceAscending: sortByPriceAscending,
      keyword: null,
    );
    Navigator.pop(
      context,
      filterValues.areAllValuesNull() ? null : filterValues,
    );
  }

  void handleClearingFilter() {
    setState(() {
      selectedMainCategory = null;
      selectedSubCategory = null;
      selectedBrand = null;
      selectedCity = null;
      sortByPriceAscending = null;
      sortByCreatedByAscending = null;
      maxPriceFromDialog = 0.0;
      minPriceFromDialog = 0.0;
    });
  }

  renderMainCategories(String language) {
    return FilterDropDownInput(
      key: Key(selectedMainCategory?.id ?? ""),
      initialValue: selectedMainCategory?.id ?? "",
      hintText: AppLocalizations.of(context).filterMainCategoryInputHint,
      items: args.allCategories
          .map((m) => {
                "value": m.id,
                "preview": language == "en"
                    ? m.title.split(";").first
                    : m.title.split(";").last
              })
          .toList(),
      onChanged: (value) {
        var mainCategory = args.allCategories.firstWhere((e) => e.id == value);
        setState(() {
          selectedMainCategory = mainCategory;
          selectedSubCategory = null;
          selectedBrand = null;
        });
      },
      validator: () {},
    );
  }

  renderSubCategories(String language) {
    var subCategoriesToDisplay = selectedMainCategory != null
        ? args.allCategories
            .firstWhere((e) => e.id == selectedMainCategory!.id)
            .subCategories
        : <SubCategory>[];
    return Visibility(
      visible: subCategoriesToDisplay.isNotEmpty,
      child: FilterDropDownInput(
        key: Key(selectedSubCategory?.id ?? ""),
        initialValue: selectedSubCategory?.id ?? "",
        hintText: AppLocalizations.of(context).filterSubCategoryInputHint,
        items: subCategoriesToDisplay
            .map((m) => {
                  "value": m.id,
                  "preview": language == "en"
                      ? m.title.split(";").first
                      : m.title.split(";").last
                })
            .toList(),
        onChanged: (value) {
          var subCategory =
              subCategoriesToDisplay.firstWhere((e) => e.id == value);
          setState(() {
            selectedSubCategory = subCategory;
          });
        },
        validator: () {},
      ),
    );
  }

  renderBrandDropdown(List<Map<String, String>>? brandToDisplay) {
    return Visibility(
      visible: brandToDisplay != null,
      child: FilterDropDownInput(
        key: Key(
          selectedBrand ?? "",
        ),
        initialValue: selectedBrand ?? "",
        hintText: AppLocalizations.of(context).filterBrandInputHint,
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

  renderCityDropdown(String language) {
    return Visibility(
      visible: args.cities.isNotEmpty,
      child: FilterDropDownInput(
        key: Key(selectedCity ?? ""),
        initialValue: selectedCity ?? "",
        hintText: AppLocalizations.of(context).filterCityInputHint,
        items: args.cities
            .map((m) => {
                  "value": m,
                  "preview":
                      language == "en" ? m.split(";").first : m.split(";").last
                })
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCity = value;
          });
        },
        validator: () {},
      ),
    );
  }

  List<Map<String, String>>? getBrandsForCategory(
    List<MainCategory> categories,
    String language,
  ) {
    if (selectedMainCategory == null) return null;

    var requiredFeildsContainingBrand = categories
        .firstWhere((e) => e.id == selectedMainCategory!.id)
        .requiredFeilds
        .where((element) => element.objectKey == "brand")
        .toList();

    if (requiredFeildsContainingBrand.isEmpty) return null;

    var brandToDisplay = requiredFeildsContainingBrand.first.dropDownValues
        .map((m) => {
              "value": m,
              "preview":
                  language == "en" ? m.split(";").first : m.split(";").last
            })
        .toList();

    return brandToDisplay;
  }

  renderConditionsCheckBoxWrapper() {
    return Column(
      children: [
        SortValuePicker(
          key: Key('$sortByPriceAscending price'),
          initialValue: sortByPriceAscending,
          sortingCriteriaTitle:
              AppLocalizations.of(context).filterSortByPriceText,
          onSortingCriteriaChanged: (value) => setState(
            () => sortByPriceAscending = value,
          ),
        ),
        const SizedBox(height: 20),
        SortValuePicker(
          key: Key('$sortByCreatedByAscending dateOfPost'),
          initialValue: sortByCreatedByAscending,
          sortingCriteriaTitle:
              AppLocalizations.of(context).filterSortByDateOfPostText,
          onSortingCriteriaChanged: (value) => setState(
            () => sortByCreatedByAscending = value,
          ),
        ),
      ],
    );
  }
}
