import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_state.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/common/post_card_list_item.dart';
import 'master_page.dart';

class SavedPostsPage extends StatefulWidget {
  const SavedPostsPage({Key? key}) : super(key: key);

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  SetFavoriteProductsCubit? setFavoriteProductsCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchFavoriteProducts();
      setFavoriteProductsCubit = context.read<SetFavoriteProductsCubit>();
    });
  }

  void fetchFavoriteProducts() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<GetFavoriteProductsCubit>().execute(
            authState.loginResult.token,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff11435E),
        appBar: const CustomAppBar(title: "Saved Posts"),
        body: CurvedContainer(
          child:
              BlocBuilder<GetFavoriteProductsCubit, GetFavoriteProductsState>(
            builder: (context, state) {
              if (state is Loaded) {
                return buildProductList(state.products);
              } else if (state is Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return buildEmptyStateContent();
              }
            },
          ),
        ),
      ),
    );
  }

  buildProductList(List<Product> products) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Swipe To Delete',
            style: TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return PostCardListItem(
                product: products[index],
                onDissmissed: () {
                  handleProductDismissal(products, index);
                },
              );
            },
            itemCount: products.length,
          ),
        ),
      ],
    );
  }

  void handleProductDismissal(List<Product> products, int index) {
    var updatedProducts = [...products];
    updatedProducts.removeWhere((element) => element.id == products[index].id);
    updateDataInLocalSource(updatedProducts);
    fetchFavoriteProducts();
  }

  void updateDataInLocalSource(List<Product> products) {
    var mappedToProductModel =
        products.map((e) => ProductModel.fromProduct(e)).toList();

    setFavoriteProductsCubit!.setFavoriteProducts(mappedToProductModel);
  }

  Widget buildEmptyStateContent() {
    return EmptyStateContent(
      captionText: "No saved Products yet!",
      hintText: "Hit the heart icon to save a product",
      buttonText: "Start Ordering",
      onButtonClicked: () {
        Navigator.pushReplacementNamed(context, MasterPage.routeName);
      },
    );
  }
}
