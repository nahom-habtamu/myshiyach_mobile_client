import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/filter/filter_criteria_model.dart';
import '../../data/models/product/page_and_limit_model.dart';
import '../../data/models/product/product_model.dart';
import '../../domain/enitites/main_category.dart';
import '../../domain/enitites/product.dart';
import '../../domain/enitites/sub_category.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/change_language/change_language_cubit.dart';
import '../bloc/display_all_products/display_all_products_cubit.dart';
import '../bloc/display_all_products/display_all_products_state.dart';
import '../bloc/filter/filter_products_cubit.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/home/category_item.dart';
import '../widgets/home/product_grid_with_out_pagination.dart';
import '../widgets/home/product_grid_with_pagination.dart';
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
  SubCategory? selectedSubCategory;
  PageAndLimitModel? pageAndLimit = PageAndLimitModel.initialDefault();
  List<Product> products = [];
  List<String> favorites = [];
  List<MainCategory> categories = [];
  String accessToken = "";
  User? currentUser;
  static final facebookAppEvents = FacebookAppEvents();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedMainCategory = filterValues?.mainCategory;
      initializeCurrentUser();
      if (products.isEmpty) {
        fetchAllNeededToDisplayProductList();
      }
    });
  }

  fetchAllNeededToDisplayProductList() {
    setState(() {
      products = [];
    });

    var pageAndLimitForSearch = PageAndLimitModel(limit: 1200, page: 1);

    context.read<DisplayAllProductsCubit>().call(
          (filterValues?.keyword != null && filterValues!.keyword!.isNotEmpty)
              ? pageAndLimitForSearch
              : PageAndLimitModel.initialDefault(),
          filterValues,
          accessToken,
          currentUser?.id ?? "",
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).homeHeader,
      ),
      body: BlocBuilder<ChangeLanguageCubit, String>(builder: (context, state) {
        return CurvedContainer(
          child: Column(
            children: [
              renderSearchAndFilterBar(),
              renderMainCategories(state),
              renderSubCategories(state),
              renderProductBuilder(),
            ],
          ),
        );
      }),
    );
  }

  renderSearchAndFilterBar() {
    if (categories.isEmpty) {
      return Container();
    }
    return SearchBar(
      onSearchFilterApplied: (value) {
        setState(() {
          filterValues = value;
          selectedMainCategory = filterValues?.mainCategory;
        });
        fetchAllNeededToDisplayProductList();
      },
      onSearchSubmitted: (value) {
        facebookAppEvents.logEvent(
          name: 'search_applied',
          parameters: {"Keyword": value},
        );
        setState(() {
          searchKeyword = value.trim();
          var addedKeyword = FilterCriteriaModel.addKeyWord(
            filterValues,
            searchKeyword.isEmpty ? null : searchKeyword,
          );
          filterValues = addedKeyword;
        });
        fetchAllNeededToDisplayProductList();
      },
      categories: categories,
      products: products,
      initialFilterCriteria: filterValues,
    );
  }

  renderProductBuilder() {
    return BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is Loaded) {
          SchedulerBinding.instance.addPostFrameCallback(
            ((timeStamp) {
              updateState(state);
              context.read<DisplayAllProductsCubit>().clear();
            }),
          );
        } else if (state is NoNetwork) {
          return buildNoNetworkContent();
        }
        return showProducts();
      },
    );
  }

  void updateState(Loaded state) {
    var updatedProductList = [...products, ...state.paginatedResult.products];
    setState(() {
      products = updatedProductList;
      favorites = [...state.favorites];
      pageAndLimit =
          PageAndLimitModel.fromPaginationLimit(state.paginatedResult.next);
      if (categories.isEmpty) {
        categories = [...state.categories];
      }
    });
  }

  showProducts() {
    var productsToDisplay =
        context.read<FilterProductsCubit>().call(products, filterValues);
    if (productsToDisplay.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No products Found'),
        ),
      );
    }
    return buildProductList(productsToDisplay);
  }

  Widget buildNoNetworkContent() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: NoNetworkContent(
            onButtonClicked: () => context.read<DisplayAllProductsCubit>().call(
                  PageAndLimitModel.initialDefault(),
                  filterValues,
                  accessToken,
                  currentUser?.id ?? "",
                ),
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
            onButtonClicked: () => context.read<DisplayAllProductsCubit>().call(
                  pageAndLimit!,
                  filterValues,
                  accessToken,
                  currentUser?.id ?? "",
                ),
          ),
        ),
      ),
    );
  }

  buildProductList(List<Product> filteredProducts) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          fetchAllNeededToDisplayProductList();
        },
        child:
            (filterValues?.keyword != null && filterValues!.keyword!.isNotEmpty)
                ? ProductGridWithOutPagination(
                    products: filteredProducts,
                    favorites: favorites,
                    searchKeyword: searchKeyword,
                  )
                : ProductGridWithPagination(
                    filterValues: filterValues,
                    products: filteredProducts,
                    favorites: favorites,
                    pageAndLimit: pageAndLimit,
                    onRefreshed: updateStateOnRefresh,
                  ),
      ),
    );
  }

  updateStateOnRefresh(newState, updatedFavorites) {
    var productsToAddInState = List<ProductModel>.from(newState.result.products)
        .where((p) => products.where((pis) => pis.id == p.id).isEmpty)
        .toList();

    setState(() {
      products = [...products, ...productsToAddInState];
      favorites = [...updatedFavorites];
      pageAndLimit = newState.result.products.isNotEmpty
          ? PageAndLimitModel.fromPaginationLimit(newState.result.next)
          : null;
    });
  }

  renderMainCategories(String language) {
    if (categories.isEmpty) {
      return Container();
    }
    return buildMainCategorySlider(categories, language);
  }

  renderSubCategories(String language) {
    if (categories.isEmpty || selectedMainCategory == null) {
      return Container();
    }

    var subCategories = categories
        .firstWhere((c) => c.id == selectedMainCategory!.id)
        .subCategories;
    return buildSubCategorySlider(subCategories, language);
  }

  buildMainCategorySlider(List<MainCategory> categories, String language) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map(
                (e) => CategoryItem(
                  category: language == "en"
                      ? e.title.split(";").first
                      : e.title.split(";").last,
                  isActive: selectedMainCategory?.id == e.id,
                  onTap: () {
                    setState(
                      () {
                        selectedSubCategory = null;
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
                    fetchAllNeededToDisplayProductList();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  buildSubCategorySlider(
    List<SubCategory> categories,
    String language,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map(
                (e) => CategoryItem(
                  category: language == "en"
                      ? e.title.split(";").first
                      : e.title.split(";").last,
                  isActive: selectedSubCategory?.id == e.id,
                  onTap: () {
                    setState(
                      () {
                        selectedSubCategory?.id == e.id
                            ? selectedSubCategory = null
                            : selectedSubCategory = e;
                        var alteredFilter = FilterCriteriaModel.addSubCategory(
                          filterValues,
                          selectedSubCategory,
                        );
                        filterValues = alteredFilter;
                      },
                    );
                    fetchAllNeededToDisplayProductList();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void initializeCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
      currentUser = authState.currentUser;
    }
  }
}
