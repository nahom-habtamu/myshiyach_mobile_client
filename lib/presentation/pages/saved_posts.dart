import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
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
        appBar: CustomAppBar(
          title: AppLocalizations.of(context).savedPostsAppBarText,
        ),
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
              }
              if (state is Error) {
                return buildErrorContent();
              }
              if (state is NoNetwork) {
                return buildNoNetworkContent();
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            AppLocalizations.of(context).savedPostsSwipeToDelete,
            style: const TextStyle(
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
    return FallBackContent(
      captionText: AppLocalizations.of(context).savedPostsEmptyCaptionText,
      hintText: AppLocalizations.of(context).savedPostsEmptyHintText,
      buttonText: AppLocalizations.of(context).savedPostsEmptyButtonText,
      onButtonClicked: () {
        Navigator.pushReplacementNamed(context, MasterPage.routeName);
      },
    );
  }

  Widget buildNoNetworkContent() {
    return NoNetworkContent(
      onButtonClicked: () => fetchFavoriteProducts(),
    );
  }

  Widget buildErrorContent() {
    return ErrorContent(
      onButtonClicked: () => fetchFavoriteProducts(),
    );
  }
}
