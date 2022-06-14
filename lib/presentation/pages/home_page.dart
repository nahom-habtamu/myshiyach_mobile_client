import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/product.dart';
import '../bloc/display_all_products/display_all_products_cubit.dart';
import '../bloc/display_all_products/display_all_products_state.dart';
import '../widgets/home/main_category_bar.dart';
import '../widgets/home/product_list.dart';
import '../widgets/home/search_bar.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> selectedMainCategories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchAllNeededToDisplayProductList();
    });
  }

  fetchAllNeededToDisplayProductList() {
    var state = context.read<DisplayAllProductsCubit>().state;
    if (state is Empty || state is Error) {
      context.read<DisplayAllProductsCubit>().call();
    }
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
                      categories: state.categories,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
                builder: (context, state) {
                  if (state is Loaded) {
                    var categories =
                        state.categories.map((e) => e.title).toList();
                    return buildCategories(categories);
                  } else {
                    return Container();
                  }
                },
              ),
              BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
                builder: (context, state) {
                  if (state is Loaded) {
                    return buildProductList(state.products, state.favorites);
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
                    return const Text('EMPTY');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  buildCategories(List<String> categories) {
    return MainCategoryBar(
      categories: categories,
      selectedMainCategories: selectedMainCategories,
      onItemTapped: (i) {
        setState(() {
          if (selectedMainCategories.contains(i)) {
            selectedMainCategories.remove(i);
          } else {
            selectedMainCategories.add(i);
          }
        });
      },
    );
  }

  buildProductList(List<Product> products, List<Product> favorites) {
    return Expanded(
      child: ProductList(products: products, favorites: favorites),
    );
  }
}
