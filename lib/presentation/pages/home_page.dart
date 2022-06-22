import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/date_time_formatter.dart';
import '../../domain/enitites/product.dart';
import '../bloc/display_all_products/display_all_products_cubit.dart';
import '../bloc/display_all_products/display_all_products_state.dart';
import '../screen_arguments/filter_page_argument.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/home/product_list.dart';
import '../widgets/home/search_bar.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FilterPageArgument? filterValues;
  String searchKeyword = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchAllNeededToDisplayProductList();
    });
  }

  fetchAllNeededToDisplayProductList() {
    // var state = context.read<DisplayAllProductsCubit>().state;
    // if (state is Empty || state is Error) {
    context.read<DisplayAllProductsCubit>().call();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 22.0),
                child: Text(
                  'Products',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
                builder: (context, state) {
                  if (state is Loaded) {
                    return SearchBar(
                      onSearchFilterApplied: (value) {
                        setState(() {
                          filterValues = value;
                        });
                      },
                      onSearchQueryChanged: (value) {
                        setState(() {
                          searchKeyword = value.trim();
                        });
                      },
                      categories: state.categories,
                      products: state.products,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
                builder: (context, state) {
                  if (state is Loaded) {
                    var productsToDisplay =
                        applyFilterToProducts(state.products);
                    if (productsToDisplay.isEmpty) {
                      return buildEmptyStateContent();
                    }

                    return buildProductList(productsToDisplay, state.favorites);
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmptyStateContent() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: EmptyStateContent(
            captionText: "No Products yet Found!",
            hintText: "Hit The button Below Reload",
            buttonText: "Reload",
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

  List<Product> applyFilterToProducts(List<Product> products) {
    if (!filterIsNotEmpty() && searchKeyword.isEmpty) {
      products.sort((a, b) => compareCreatedAt(a, b));
      return products;
    }

    var filteredData = products
        .where(
          (product) =>
              checkMainCategoryMatch(product) &&
              checkPriceMatch(product) &&
              checkKeywordMatch(product),
        )
        .toList();
    filteredData.sort(
      (a, b) => a.price.compareTo(b.price),
    );

    return filterValues!.orderByAscending
        ? filteredData
        : filteredData.reversed.toList();
  }

  int compareCreatedAt(Product a, Product b) {
    var firstDate = DateFormatterUtil.parseDate(a.createdAt);
    var secondDate = DateFormatterUtil.parseDate(b.createdAt);

    return secondDate.compareTo(firstDate);
  }

  bool filterIsNotEmpty() {
    return filterValues != null &&
        (filterValues!.categories.isNotEmpty ||
            (filterValues!.maxValue != 0 && filterValues!.minValue != 0) ||
            filterValues!.orderByAscending);
  }

  bool checkKeywordMatch(Product product) {
    return product.description.contains(
          RegExp(r'' + searchKeyword, caseSensitive: false),
        ) ||
        product.title.contains(
          RegExp(r'' + searchKeyword, caseSensitive: false),
        ) ||
        product.brand.contains(
          RegExp(r'' + searchKeyword, caseSensitive: false),
        );
  }

  bool checkPriceMatch(Product product) {
    if (filterValues == null ||
        (filterValues!.maxValue == 0 && filterValues!.minValue == 0)) {
      return true;
    }

    return product.price <= filterValues!.maxValue &&
        product.price >= filterValues!.minValue;
  }

  bool checkMainCategoryMatch(Product product) {
    return filterValues?.categories == null || filterValues!.categories.isEmpty
        ? true
        : filterValues!.categories.any(
            (cat) => cat.id == product.mainCategory,
          );
  }
}
