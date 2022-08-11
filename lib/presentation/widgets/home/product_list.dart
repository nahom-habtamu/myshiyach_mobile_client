import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/product/page_and_limit_model.dart';
import '../../../data/models/product/product_model.dart';
import '../../../domain/enitites/product.dart';
import '../../bloc/get_all_products/get_all_products_cubit.dart';
import '../../bloc/get_all_products/get_all_products_state.dart';
import '../../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import 'custom_footer_for_lazy_loading.dart';
import 'product_list_item.dart';

class ProductList extends StatefulWidget {
  final List<Product> favorites;
  final List<Product> products;
  final PageAndLimitModel? pageAndLimit;
  final Function(Loaded) onRefreshed;
  const ProductList({
    Key? key,
    required this.products,
    required this.favorites,
    required this.pageAndLimit,
    required this.onRefreshed,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  SetFavoriteProductsCubit? setFavoriteProductsCubit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllProductsCubit, GetAllProductsState>(
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
            context.read<GetAllProductsCubit>().call(widget.pageAndLimit!);
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
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.onRefreshed(state);
      context.read<GetAllProductsCubit>().clear();
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
