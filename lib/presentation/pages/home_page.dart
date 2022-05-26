import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../bloc/get_all_products/get_all_products_cubit.dart';
import '../bloc/get_all_products/get_all_products_state.dart';
import '../bloc/get_categories/get_categories_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import 'post_detail_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> favorites = [];
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
      initializeFavoriteProducts();
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

  initializeFavoriteProducts() async {
    var result = await context
        .read<GetFavoriteProductsCubit>()
        .getFavoriteProducts
        .call();
    setState(() {
      favorites = [...result];
    });
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        onChanged: (value) => {},
                        decoration: const InputDecoration(
                          labelText: "Search Item",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 30,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    )
                  ],
                ),
              ),
              categories.isNotEmpty ? buildCategories() : Container(),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedMainCategory = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 3,
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: index == selectedMainCategory
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: index == selectedMainCategory
                        ? const Color(0xff11435E)
                        : null,
                    border: index != selectedMainCategory
                        ? Border.all(color: const Color(0xFF686666))
                        : null,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  buildProductList(List<Product> products) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetAllProductsCubit>().call();
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.83,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return buildProduct(products[index]);
        },
      ),
    );
  }

  GestureDetector buildProduct(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PostDetailPage.routeName,
            arguments: product);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width * 0.45,
        height: 210,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            renderProductListItemImage(product.productImages.first),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    renderTitle(product.title),
                    renderDescription(product.description),
                    renderPrice(product.price),
                    renderTimerAndFavoriteIcon(product)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox renderTitle(title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 32,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  SizedBox renderDescription(description) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 10,
      child: Text(
        description,
        style: const TextStyle(
          color: Color(0xff888888),
          fontSize: 8,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Padding renderPrice(price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: const Color(0xffF5FFF8),
        width: MediaQuery.of(context).size.width * 0.45,
        child: Text(
          '\$${price.toString()}',
          style: const TextStyle(
            color: Color(0xff34A853),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Row renderTimerAndFavoriteIcon(Product product) {
    var duplicate =
        favorites.where((element) => element.id == product.id).toList();

    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 18,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            product.createdAt,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (duplicate.isNotEmpty) {
              favorites.removeWhere((element) => element.id == product.id);
              setState(() {});
            } else {
              var newFavorites = [...favorites, product];
              setState(() {
                favorites = newFavorites;
              });
            }
            List<ProductModel> favoritesToSave = parseListToProductModelList();
            setFavoriteProductsCubit!.setFavoriteProducts.call(favoritesToSave);
          },
          child: CircleAvatar(
            radius: 14,
            backgroundColor: const Color.fromRGBO(233, 225, 225, 1),
            child: Icon(
              duplicate.isEmpty ? Icons.favorite_border : Icons.favorite,
              size: 20,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  List<ProductModel> parseListToProductModelList() {
    var favoritesToSave =
        favorites.map((e) => ProductModel.fromProduct(e)).toList();
    return favoritesToSave;
  }

  SizedBox renderProductListItemImage(image) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.45,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: Image.network(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
