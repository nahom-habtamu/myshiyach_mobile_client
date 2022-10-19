// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/product/product_model.dart';
import '../../../domain/enitites/product.dart';
import '../../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../common/empty_state_content.dart';
import '../common/error_content.dart';
import 'product_grid_item.dart';

class ProductGridWithOutPagination extends StatefulWidget {
  List<Product> favorites;
  final List<Product> products;
  final String searchKeyword;
  ProductGridWithOutPagination({
    Key? key,
    required this.products,
    required this.favorites,
    required this.searchKeyword,
  }) : super(key: key);

  @override
  State<ProductGridWithOutPagination> createState() =>
      _ProductGridWithOutPaginationState();
}

class _ProductGridWithOutPaginationState
    extends State<ProductGridWithOutPagination> {
  SetFavoriteProductsCubit? setFavoriteProductsCubit;
  @override
  void initState() {
    super.initState();
  }

  Widget buildErrorContent() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: ErrorContent(
          onButtonClicked: () => {},
        ),
      ),
    );
  }

  Widget buildEmptyStateContent() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: FallBackContent(
          captionText: AppLocalizations.of(context).homeEmptyProductText,
          hintText:
              AppLocalizations.of(context).homeRetryFetchProductButtonLabel,
          buttonText:
              AppLocalizations.of(context).homeRetryFetchProductButtonText,
          onButtonClicked: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height) *
            1.47,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return buildProduct(widget.products[index]);
      },
    );
  }

  ProductGridItem buildProduct(Product product) {
    var duplicate =
        widget.favorites.where((element) => element.id == product.id).toList();
    return ProductGridItem(
      product: product,
      isFavorite: duplicate.isEmpty,
      onFavoritesTap: () {
        updateFavorites(duplicate, product);
      },
    );
  }

  void updateFavorites(List<Product> duplicate, Product product) {
    if (duplicate.isNotEmpty) {
      widget.favorites.removeWhere((element) => element.id == product.id);
      setState(() {});
    } else {
      setState(() {
        widget.favorites = [...widget.favorites, product];
      });
    }
    List<ProductModel> favoritesToSave = parseListToProductModelList();
    context
        .read<SetFavoriteProductsCubit>()
        .setFavoriteProducts
        .call(favoritesToSave);
  }

  List<ProductModel> parseListToProductModelList() {
    var favoritesToSave =
        widget.favorites.map((e) => ProductModel.fromProduct(e)).toList();
    return favoritesToSave;
  }
}
