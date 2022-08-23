import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../data/models/product/page_and_limit_model.dart';
import '../../../data/models/product/product_model.dart';
import '../../../domain/enitites/product.dart';
import '../../bloc/get_paginated_products/get_paginated_products_cubit.dart';
import '../../bloc/get_paginated_products/get_paginated_products_state.dart';
import '../../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../common/empty_state_content.dart';
import '../common/error_content.dart';
import 'custom_footer_for_lazy_loading.dart';
import 'product_list_item.dart';

class ProductList extends StatefulWidget {
  final List<Product> favorites;
  final List<Product> products;
  final PageAndLimitModel? pageAndLimit;
  final FilterCriteriaModel? filterValues;
  final Function(Loaded) onRefreshed;
  final RefreshController refreshController;
  const ProductList({
    Key? key,
    required this.products,
    required this.favorites,
    required this.pageAndLimit,
    required this.filterValues,
    required this.onRefreshed,
    required this.refreshController,
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
    initializeState();
  }

  void initializeState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      favorites = [...widget.favorites];
      setFavoriteProductsCubit = context.read<SetFavoriteProductsCubit>();
    });
  }

  Widget buildErrorContent() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: ErrorContent(
          onButtonClicked: () => context
              .read<GetPaginatedProductsCubit>()
              .call(widget.pageAndLimit!, widget.filterValues),
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
          onButtonClicked: () {
            if (widget.pageAndLimit != null) {
              context
                  .read<GetPaginatedProductsCubit>()
                  .call(widget.pageAndLimit!, widget.filterValues);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPaginatedProductsCubit, GetPaginatedProductsState>(
        builder: (context, state) {
      if (state is Loaded) {
        handleAddingNewItemsAndUpdatingState(state);
      } else if (state is Error) {
        widget.refreshController.loadFailed();
      }
      return SmartRefresher(
        controller: widget.refreshController,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          widget.refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          if (widget.pageAndLimit != null) {
            context.read<GetPaginatedProductsCubit>().call(
                  widget.pageAndLimit!,
                  widget.filterValues,
                );
            widget.refreshController.loadComplete();
          } else {
            widget.refreshController.loadNoData();
          }
        },
        header: const WaterDropHeader(),
        enablePullUp: true,
        enablePullDown: false,
        footer: const CustomFooterForLazyLoading(),
        child: GridView.builder(
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
        ),
      );
    });
  }

  void handleAddingNewItemsAndUpdatingState(Loaded state) {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.onRefreshed(state);
      context.read<GetPaginatedProductsCubit>().clear();
    });
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
