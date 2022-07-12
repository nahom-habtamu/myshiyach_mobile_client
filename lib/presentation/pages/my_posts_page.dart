import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/product.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/get_my_products/get_my_products_cubit.dart';
import '../bloc/get_my_products/get_my_products_state.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/common/post_card_list_item.dart';
import 'add_post_page.dart';

class MyPostsPage extends StatefulWidget {
  static String routeName = '/myPostsPage';
  const MyPostsPage({Key? key}) : super(key: key);

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  String accessToken = "";

  @override
  void initState() {
    super.initState();
    initAccessTokenAndFetchMyPosts();
  }

  void initAccessTokenAndFetchMyPosts() {
    var authState = context.read<AuthCubit>().state;

    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
      context.read<GetMyProductsCubit>().call(authState.currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: const CustomAppBar(title: "My Posts"),
      body: CurvedContainer(
        child: buildMyPosts(),
      ),
    );
  }

  buildMyPosts() {
    return BlocBuilder<GetMyProductsCubit, GetMyProductsState>(
      builder: (context, state) {
        if (state is GetMyProductsLoaded) {
          return buildProductList(state.products);
        } else if (state is GetMyProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return buildEmptyStateContent();
        }
      },
    );
  }

  buildEmptyStateContent() {
    return EmptyStateContent(
      captionText: "No Products yet!",
      hintText: "Experience Adding products by cliking the button Below",
      buttonText: "Go To Add",
      onButtonClicked: () {
        Navigator.pushReplacementNamed(context, AddPostPage.routeName);
      },
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
            shrinkWrap: true,
            itemBuilder: (context, index) => PostCardListItem(
              product: products[index],
              onDissmissed: () {
                context.read<DeleteProductByIdCubit>().call(
                      products[index].id,
                      accessToken,
                    );
                initAccessTokenAndFetchMyPosts();
              },
            ),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}
