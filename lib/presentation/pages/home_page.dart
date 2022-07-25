import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mnale_client/presentation/widgets/common/curved_container.dart';
import 'package:mnale_client/presentation/widgets/common/custom_app_bar.dart';

import '../../domain/enitites/main_category.dart';
import '../../domain/enitites/product.dart';
import '../../data/models/filter/filter_criteria_model.dart';
import '../bloc/display_all_products/display_all_products_cubit.dart';
import '../bloc/display_all_products/display_all_products_state.dart';
import '../bloc/filter/filter_products_cubit.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/home/search_bar.dart';
import '../widgets/home/product_list.dart';
import '../widgets/home/category_item.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FilterCriteriaModel? filterValues;
  String searchKeyword = "";
  MainCategory? selectedMainCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      selectedMainCategory = filterValues?.mainCategory;
      fetchAllNeededToDisplayProductList();
    });
  }

  fetchAllNeededToDisplayProductList() {
    context.read<DisplayAllProductsCubit>().call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff11435E),
        appBar: CustomAppBar(title: AppLocalizations.of(context).homeHeader),
        body: CurvedContainer(
          child: Column(
            children: [
              renderSearchAndFilterBar(),
              renderCategories(),
              renderProductBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  renderSearchAndFilterBar() {
    return BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
      builder: (context, state) {
        if (state is Loaded) {
          return SearchBar(
            onSearchFilterApplied: (value) {
              setState(() {
                filterValues = value;
                selectedMainCategory = filterValues?.mainCategory;
              });
            },
            onSearchQueryChanged: (value) {
              setState(() {
                searchKeyword = value.trim();
                var addedKeyword =
                    FilterCriteriaModel.addKeyWord(filterValues, searchKeyword);
                filterValues = addedKeyword;
              });
            },
            categories: state.categories,
            products: state.products,
            initialFilterCriteria: filterValues,
          );
        } else {
          return Container();
        }
      },
    );
  }

  renderProductBuilder() {
    return BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
      builder: (context, state) {
        if (state is Loaded) {
          return showProducts(state);
        } else if (state is Loading) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is Error) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return buildEmptyStateContent();
        }
      },
    );
  }

  showProducts(Loaded state) {
    var productsToDisplay = filterValues == null
        ? state.products
        : context
            .read<FilterProductsCubit>()
            .call(state.products, filterValues!);
    if (productsToDisplay.isEmpty) {
      return buildEmptyStateContent();
    }
    return buildProductList(
      productsToDisplay,
      state.favorites,
    );
  }

  Widget buildEmptyStateContent() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: EmptyStateContent(
            captionText: AppLocalizations.of(context).homeEmptyProductText,
            hintText:
                AppLocalizations.of(context).homeRetryFetchProductButtonLabel,
            buttonText:
                AppLocalizations.of(context).homeRetryFetchProductButtonText,
            onButtonClicked: () {
              context.read<DisplayAllProductsCubit>().call();
            },
          ),
        ),
      ),
    );
  }

  buildProductList(List<Product> products, List<Product> favorites) {
    return Expanded(
      child: ProductList(products: products, favorites: favorites),
    );
  }

  renderCategories() {
    return BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
      builder: (context, state) {
        if (state is Loaded) {
          return buildCategorySlider(state.categories);
        } else {
          return Container();
        }
      },
    );
  }

  buildCategorySlider(List<MainCategory> categories) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map(
                (e) => CategoryItem(
                  category: e.title,
                  isActive: selectedMainCategory?.id == e.id,
                  onTap: () {
                    setState(
                      () {
                        selectedMainCategory?.id == e.id
                            ? selectedMainCategory = null
                            : selectedMainCategory = e;
                        var alteredFilter = FilterCriteriaModel.addMainCategory(
                          filterValues,
                          selectedMainCategory,
                        );
                        filterValues = alteredFilter;
                      },
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
