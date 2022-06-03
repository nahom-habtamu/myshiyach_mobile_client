import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/enitites/product.dart';
import '../../../data/models/product/product_model.dart';
import '../../bloc/display_all_products/display_all_products_cubit.dart';
import '../../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import 'product_list_item.dart';

class ProductList extends StatefulWidget {
  final List<Product> favorites;
  final List<Product> products;
  const ProductList({
    Key? key,
    required this.products,
    required this.favorites,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  SetFavoriteProductsCubit? setFavoriteProductsCubit;
  List<Product> favorites = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setFavoriteProductsCubit = context.read<SetFavoriteProductsCubit>();
      setState(() {
        favorites = [...widget.favorites];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DisplayAllProductsCubit>().call();
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.83,
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          return buildProduct(widget.products[index]);
        },
      ),
    );
  }

  ProductListItem buildProduct(Product product) {
    var duplicate =
        favorites.where((element) => element.id == product.id).toList();
    return ProductListItem(
      product: product,
      isFavorite: duplicate.isEmpty,
      onTap: () {
        updateFavorites(duplicate, product);
      },
    );
  }

  void updateFavorites(List<Product> duplicate, Product product) {
    if (duplicate.isNotEmpty) {
      favorites.removeWhere((element) => element.id == product.id);
      setState(() {});
    } else {
      setState(() {
        favorites = [...favorites, product];
      });
    }
    List<ProductModel> favoritesToSave = parseListToProductModelList();
    setFavoriteProductsCubit!.setFavoriteProducts.call(favoritesToSave);
  }

  List<ProductModel> parseListToProductModelList() {
    var favoritesToSave =
        favorites.map((e) => ProductModel.fromProduct(e)).toList();
    return favoritesToSave;
  }
}
