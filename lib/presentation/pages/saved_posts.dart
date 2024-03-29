import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/enitites/product.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_state.dart';
import '../bloc/update_favorite_products/update_favorite_products_cubit.dart';
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
  UpdateFavoriteProductsCubit? updateFavoriteProductsCubit;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchFavoriteProducts();
      updateFavoriteProductsCubit = context.read<UpdateFavoriteProductsCubit>();
    });
  }

  void fetchFavoriteProducts() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<GetFavoriteProductsCubit>().execute(
            authState.loginResult.token,
            authState.currentUser.id,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).savedPostsAppBarText,
      ),
      body: CurvedContainer(
        child: BlocBuilder<GetFavoriteProductsCubit, GetFavoriteProductsState>(
          builder: (context, state) {
            if (state is Loaded) {
              SchedulerBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  setState(() {
                    products = state.products;
                  });
                },
              );
              return buildProductList();
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
    );
  }

  buildProductList() {
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
                onDissmissed: (product) {
                  handleProductDismissal(product);
                },
              );
            },
            itemCount: products.length,
          ),
        ),
      ],
    );
  }

  void handleProductDismissal(Product product) {
    setState(() {
      products.removeWhere((element) => element.id == product.id);
      updateFavoriteProducts(products);
    });

    // fetchFavoriteProducts();
  }

  void updateFavoriteProducts(List<Product> products) {
    var mappedToIdList = products.map((e) => e.id).toList();
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      context.read<AuthCubit>().updateFavoriteProducts(
            authState.loginResult.token,
            authState.currentUser,
            mappedToIdList,
          );

      updateFavoriteProductsCubit!.updateFavoriteProducts(
        authState.currentUser.id,
        authState.loginResult.token,
        mappedToIdList,
      );
    }
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
