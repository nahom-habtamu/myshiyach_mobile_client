import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_state.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../bloc/refresh_product/refresh_product_cubit.dart';
import '../bloc/refresh_product/refresh_product_state.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../widgets/post_detail/post_content_to_show.dart';
import '../widgets/post_detail/post_detail_app_bar.dart';
import 'edit_post_page.dart';

class PostDetailPage extends StatefulWidget {
  static String routeName = "/postDetail";
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Product? product;
  User? currentUser;
  String? authToken;
  List<Product> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initalizeNeededData();
    });
  }

  void initalizeNeededData() {
    setState(() {
      currentUser = getCurrentUser();
      authToken = getToken();
      product = ModalRoute.of(context)!.settings.arguments as Product;
    });
    context.read<HandleGoingToMessageCubit>().clear();
    context.read<GetFavoriteProductsCubit>().execute(authToken!);
    context.read<RefreshProductCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFavoriteProductsCubit, GetFavoriteProductsState>(
      builder: (context, state) {
        if (state is Loading || product == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is Loaded) {
          favoriteProducts = [...state.products];
        }
        return Scaffold(
          appBar: renderAppBar(),
          body: renderBody(),
        );
      },
    );
  }

  renderBody() {
    return BlocBuilder<RefreshProductCubit, RefreshProductState>(
        builder: (context, state) {
      if (state is RefreshPostLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is RefreshPostError) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error on Refreshing Product'),
            ),
          );
        });
      }

      if (state is RefreshPostSuccessfull) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            product = state.product;
          });
        });
      }
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: PostContentToShow(
          product: product!,
          currentUser: currentUser!,
          authToken: authToken!,
        ),
      );
    });
  }

  renderAppBar() {
    var duplicate = favoriteProducts.where((e) => e.id == product!.id).toList();
    return PostDetailAppBar(
      onAppBarMenuClicked: (value) => handleAppBarMenuClicked(value),
      isFavorite: duplicate.isEmpty,
      showActions: product != null && currentUser!.id == product!.createdBy,
    );
  }

  User? getCurrentUser() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      return authState.currentUser;
    }
    return null;
  }

  String? getToken() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      return authState.loginResult.token;
    }
    return null;
  }

  handleAppBarMenuClicked(String value) {
    switch (value) {
      case "Edit":
        Navigator.pushReplacementNamed(
          context,
          EditPostPage.routeName,
          arguments: product,
        );
        break;
      case "Refresh":
        refreshProduct(product!);
        break;
      case "Save":
        updateFavorites(product!);
        break;
      default:
    }
  }

  void updateFavorites(Product product) {
    setState(() {
      favoriteProducts = [...favoriteProducts, product];
    });
    List<ProductModel> favoritesToSave =
        favoriteProducts.map((e) => ProductModel.fromProduct(e)).toList();
    context
        .read<SetFavoriteProductsCubit>()
        .setFavoriteProducts
        .call(favoritesToSave);
  }

  void refreshProduct(Product product) {
    context.read<RefreshProductCubit>().call(product.id, authToken!);
  }
}
