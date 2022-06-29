import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height) *
              1.25,
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
