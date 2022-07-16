import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/date_time_formatter.dart';
import '../../core/utils/price_formatter.dart';
import '../../data/models/conversation/add_conversation_model.dart';
import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_state.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_state.dart';
import '../bloc/refresh_product/refresh_product_cubit.dart';
import '../bloc/refresh_product/refresh_product_state.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../widgets/common/action_button.dart';
import '../widgets/post_detail/post_detail_carousel.dart';
import 'chat_detail_page.dart';
import 'edit_post_page.dart';
import 'master_page.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, () {
        setState(() {
          currentUser = getCurrentUser();
          authToken = getToken();
          product = ModalRoute.of(context)!.settings.arguments as Product;
        });
        context.read<HandleGoingToMessageCubit>().clear();
        context.read<DeleteProductByIdCubit>().clear();
        context.read<GetFavoriteProductsCubit>().execute(authToken!);
        context.read<RefreshProductCubit>().clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFavoriteProductsCubit, GetFavoriteProductsState>(
      builder: (context, state) {
        if (state is Loading || product == null) {
          return const SafeArea(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (state is Loaded) {
          favoriteProducts = [...state.products];
        }
        return SafeArea(
          child: Scaffold(
            appBar: renderAppBar(),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: renderMainContent(),
            ),
          ),
        );
      },
    );
  }

  renderMainContent() {
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

      return Column(
        children: [
          PostDetailCarousel(
            items: [...product!.productImages],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, left: 5, right: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                subtitle: Text(product!.title),
                                title: const Text('Title'),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                subtitle: Text(product!.city),
                                title: const Text('City'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [...buildOtherDetail()],
                        ),
                      ),
                      IntrinsicHeight(
                        child: ListTile(
                          subtitle: renderPrice(),
                          title: const Text('Price'),
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                subtitle: renderTimeContent(product!.createdAt),
                                title: const Text('Created'),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                subtitle:
                                    renderTimeContent(product!.refreshedAt),
                                title: const Text('Updated'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color(0xFFC7C4C4),
                                blurRadius: 10,
                                spreadRadius: 5,
                              )
                            ], color: Colors.white),
                            child: ListTile(
                              subtitle: Text(product!.description),
                              title: const Text('Description'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      renderPostDetailButtonSection(),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }

  Text renderPrice() {
    return Text(
      '\$' +
          PriceFormatterUtil.formatToPrice(
            product!.price,
          ),
      style: const TextStyle(
        color: Color(0xff34A853),
        fontSize: 24,
        height: 1.5,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  renderTimeContent(String time) {
    return Text(
      DateFormatterUtil.formatProductCreatedAtTime(
        time,
      ),
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }

  buildOtherDetail() {
    if (product!.productDetail == null || product!.productDetail!.isEmpty) {
      return [];
    }
    return product!.productDetail!.entries
        .toList()
        .map(
          (e) => Expanded(
            child: ListTile(
              title: Text(e.value),
              subtitle: Text(e.key),
            ),
          ),
        )
        .toList();
  }

  AppBar renderAppBar() {
    return AppBar(
      title: const Text(
        'Post Detail',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xff11435E),
      elevation: 0,
      centerTitle: true,
      actions: [
        Visibility(
          visible: product != null && currentUser!.id == product!.createdBy,
          child: PopupMenuButton<String>(
            onSelected: (value) => handleAppBarMenuClicked(value),
            itemBuilder: (BuildContext context) {
              var duplicate = favoriteProducts
                  .where((element) => element.id == product!.id)
                  .toList();

              var contentToShowOnPopup = duplicate.isEmpty
                  ? {'Edit', 'Refresh', "Save"}
                  : {
                      'Edit',
                      'Refresh',
                    };
              return contentToShowOnPopup.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }

  renderPostDetailButtonSection() {
    return currentUser!.id != product!.createdBy
        ? goToChatDetailButton(product!.createdBy)
        : Container();
  }

  goToChatDetailButton(String postCreatedBy) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<HandleGoingToMessageCubit, HandleGoingToMessageState>(
            builder: (context, state) {
              if (state is HandleGoingToMessageLoading) {
                return const CircularProgressIndicator();
              }
              if (state is HandleGoingToMessageSuccessfull) {
                context.read<GetConversationByIdCubit>().call(
                      state.chatDetailPageArguments.conversationId,
                    );
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(
                    context,
                    ChatDetailPage.routeName,
                    arguments: state.chatDetailPageArguments,
                  );
                });
              }
              return ActionButton(
                onPressed: () {
                  var addConversation = AddConversationModel(
                    memberOne: currentUser!.id,
                    memberTwo: postCreatedBy,
                  );
                  context.read<HandleGoingToMessageCubit>().call(
                        addConversation,
                        currentUser!.id,
                        authToken!,
                      );
                },
                text: "Send Message",
                isCurved: false,
              );
            },
          ),
        ],
      ),
    );
  }

  void naviagateToMasterPage() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(
        context,
        MasterPage.routeName,
      );
    });
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
