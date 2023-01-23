// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../data/models/product/page_and_limit_model.dart';
import '../../../data/models/product/product_model.dart';
import '../../../domain/enitites/product.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/get_paginated_products/get_paginated_products_cubit.dart';
import '../../bloc/get_paginated_products/get_paginated_products_state.dart';
import '../../bloc/update_favorite_products/update_favorite_products_cubit.dart';
import '../common/empty_state_content.dart';
import '../common/error_content.dart';
import 'custom_footer_for_lazy_loading.dart';
import 'product_grid_item.dart';

class ProductGridWithPagination extends StatefulWidget {
  List<Product> favorites;
  final List<Product> products;
  final PageAndLimitModel? pageAndLimit;
  final FilterCriteriaModel? filterValues;
  final Function(Loaded, List<Product>) onRefreshed;
  ProductGridWithPagination({
    Key? key,
    required this.products,
    required this.favorites,
    required this.pageAndLimit,
    required this.filterValues,
    required this.onRefreshed,
  }) : super(key: key);

  @override
  State<ProductGridWithPagination> createState() =>
      _ProductGridWithPaginationState();
}

class _ProductGridWithPaginationState extends State<ProductGridWithPagination> {
  UpdateFavoriteProductsCubit? updateFavoriteProductsCubit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
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
        _refreshController.loadFailed();
      }
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          if (widget.pageAndLimit != null) {
            context.read<GetPaginatedProductsCubit>().call(
                  widget.pageAndLimit!,
                  widget.filterValues,
                );
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onRefreshed(state, widget.favorites);
      context.read<GetPaginatedProductsCubit>().clear();
    });
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
        widget.favorites = [product, ...widget.favorites];
      });
    }
    List<ProductModel> favoritesToSave = parseListToProductModelList();

    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<AuthCubit>().updateFavoriteProducts(
            authState.loginResult.token,
            authState.currentUser,
            favoritesToSave.map((e) => e.id).toList(),
          );
      context.read<UpdateFavoriteProductsCubit>().execute(
            authState.currentUser.id,
            authState.loginResult.token,
            favoritesToSave,
          );
    }
  }

  List<ProductModel> parseListToProductModelList() {
    var favoritesToSave =
        widget.favorites.map((e) => ProductModel.fromProduct(e)).toList();
    return favoritesToSave;
  }
}
