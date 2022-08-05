import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/filter/filter_criteria_model.dart';
import '../../data/models/product/page_and_limit_model.dart';
import '../../domain/enitites/main_category.dart';
import '../bloc/display_all_products/display_all_products_cubit.dart';
import '../bloc/display_all_products/display_all_products_state.dart';
import '../bloc/filter/filter_products_cubit.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/home/category_item.dart';
import '../widgets/home/product_list.dart';
import '../widgets/home/search_bar.dart';

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
  var initialPageAndLimit = PageAndLimitModel.initialDefault();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      selectedMainCategory = filterValues?.mainCategory;
      fetchAllNeededToDisplayProductList();
    });
  }

  fetchAllNeededToDisplayProductList() {
    context.read<DisplayAllProductsCubit>().call(initialPageAndLimit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            products: state.paginatedResult.products,
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
        } else if (state is NoNetwork) {
          return buildNoNetworkContent();
        } else if (state is Error) {
          return buildErrorContent();
        } else {
          return buildEmptyStateContent();
        }
      },
    );
  }

  showProducts(Loaded state) {
    var products = state.paginatedResult.products;
    var productsToDisplay = filterValues == null
        ? products
        : context.read<FilterProductsCubit>().call(products, filterValues!);

    if (productsToDisplay.isEmpty) {
      return buildEmptyStateContent();
    }
    return buildProductList(state);
  }

  Widget buildNoNetworkContent() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: NoNetworkContent(
            onButtonClicked: () => context
                .read<DisplayAllProductsCubit>()
                .call(initialPageAndLimit),
          ),
        ),
      ),
    );
  }

  Widget buildErrorContent() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: ErrorContent(
            onButtonClicked: () => context
                .read<DisplayAllProductsCubit>()
                .call(initialPageAndLimit),
          ),
        ),
      ),
    );
  }

  Widget buildEmptyStateContent() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: FallBackContent(
            captionText: AppLocalizations.of(context).homeEmptyProductText,
            hintText:
                AppLocalizations.of(context).homeRetryFetchProductButtonLabel,
            buttonText:
                AppLocalizations.of(context).homeRetryFetchProductButtonText,
            onButtonClicked: () {
              context.read<DisplayAllProductsCubit>().call(initialPageAndLimit);
            },
          ),
        ),
      ),
    );
  }

  buildProductList(Loaded state) {
    return Expanded(
      child: ProductList(
        initialProducts: state.paginatedResult.products,
        favorites: state.favorites,
        initialPageAndLimit:
            PageAndLimitModel.fromPaginationLimit(state.paginatedResult.next!),
      ),
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
