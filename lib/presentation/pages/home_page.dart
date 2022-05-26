import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/product.dart';
import '../bloc/get_all_products/get_all_products_cubit.dart';
import '../bloc/get_all_products/get_all_products_state.dart';
import '../bloc/get_categories/get_categories_cubit.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
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
  List<String> categories = ["All"];
  SetFavoriteProductsCubit? setFavoriteProductsCubit;
  int selectedMainCategory = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchAllCategories();
      fetchAllProducts();
      setFavoriteProductsCubit = context.read<SetFavoriteProductsCubit>();
    });
  }

  fetchAllCategories() async {
    var mainCategories =
        await context.read<GetAllCategoriesCubit>().getAllCategories.call();
    setState(() {
      categories = [
        ...categories,
        ...mainCategories.map((e) => e.title).toList()
      ];
    });
  }

  fetchAllProducts() {
    var productState = context.read<GetAllProductsCubit>().state;
    if (productState is Empty || productState is Error) {
      context.read<GetAllProductsCubit>().call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 22.0),
                child: Text(
                  'Products',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const SearchBar(),
              buildCategories(),
              Expanded(
                child: BlocBuilder<GetAllProductsCubit, GetAllProductsState>(
                  builder: (context, state) {
                    if (state is Loaded) {
                      return Center(
                        child: buildProductList(state.products),
                      );
                    } else if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildCategories() {
    return MainCategoryBar(
      categories: categories,
      selectedMainCategory: selectedMainCategory,
      onItemTapped: (i) {
        setState(() {
          selectedMainCategory = i;
        });
      },
    );
  }

  buildProductList(List<Product> products) {
    return ProductList(products: products);
  }
}
