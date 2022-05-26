import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_state.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import 'post_detail_page.dart';

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
    return ListView.builder(
      itemBuilder: (context, index) {
        return SavedPostListItem(
          product: products[index],
          onDissmissed: () {
            var updatedProducts = [...products];
            updatedProducts
                .removeWhere((element) => element.id == products[index].id);
            updateDataInLocalSource(updatedProducts);
            context.read<GetFavoriteProductsCubit>().execute();
          },
        );
      },
      itemCount: products.length,
    );
  }

  void updateDataInLocalSource(List<Product> products) {
    var mappedToProductModel =
        products.map((e) => ProductModel.fromProduct(e)).toList();

    setFavoriteProductsCubit!.setFavoriteProducts(mappedToProductModel);
  }

  Widget buildEmptyStateContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: const Text(
            'No saved Products yet!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: const Text(
            'Hit the heart icon to save a product',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Start Ordering'),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xff11435E),
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SavedPostListItem extends StatelessWidget {
  final Product product;
  final Function onDissmissed;
  const SavedPostListItem({
    Key? key,
    required this.product,
    required this.onDissmissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
      onDismissed: (DismissDirection direction) {
        onDissmissed();
      },
      key: ValueKey<String>(product.id),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            PostDetailPage.routeName,
            arguments: product,
          );
        },
        child: Card(
          color: Colors.white.withOpacity(0.9),
          elevation: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    backgroundImage: NetworkImage(product.productImages.first),
                    radius: 45,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(product.description),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
