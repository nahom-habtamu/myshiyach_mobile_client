import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_state.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
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
      context.read<GetFavoriteProductsCubit>().execute();
      setFavoriteProductsCubit = context.read<SetFavoriteProductsCubit>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        appBar: AppBar(
          title: const Text(
            'Saved Posts',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 25,
              left: 25,
              right: 25,
            ),
            width: MediaQuery.of(context).size.width,
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
                  var updatedProducts = [...products];
                  updatedProducts.removeWhere(
                      (element) => element.id == products[index].id);
                  updateDataInLocalSource(updatedProducts);
                  context.read<GetFavoriteProductsCubit>().execute();
                },
              );
            },
            itemCount: products.length,
          ),
        ),
      ],
    );
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
