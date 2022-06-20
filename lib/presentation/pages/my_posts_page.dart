import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/product.dart';
import '../../domain/usecases/delete_product_by_id.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_my_products/get_my_products_cubit.dart';
import '../bloc/get_my_products/get_my_products_state.dart';
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
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
      context.read<GetMyProductsCubit>().call(authState.currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      appBar: AppBar(
        title: const Text(
          'My Posts',
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
          height: MediaQuery.of(context).size.height * 0.9,
          child: buildMyPosts(),
        ),
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => PostCardListItem(
              product: products[index],
              onDissmissed: () {
                context.read<DeleteProductById>().call(
                      products[index].id,
                      accessToken,
                    );
              },
            ),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}
