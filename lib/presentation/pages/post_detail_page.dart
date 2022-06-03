import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_state.dart';
import '../widgets/post_detail/post_detail_carousel.dart';
import '../widgets/post_detail/post_detail_information_item.dart';
import 'chat_list_page.dart';
import 'master_page.dart';

class PostDetailPage extends StatefulWidget {
  static String routeName = "/postDetail";
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  User? currentUser;
  String? authToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        currentUser = getCurrentUser();
        authToken = getToken();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Post Detail',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              PostDetailCarousel(
                items: [...product.productImages],
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 15,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              color: Color(0xff11435E),
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_sharp,
                                color: Colors.grey,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                product.createdAt,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$${product.price.toString()}',
                            style: const TextStyle(
                              color: Color(0xff34A853),
                              fontSize: 24,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: PostDetailInformationItem(
                              informationKey: "Description",
                              informationValue: product.description,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          buildOtherInformation(product.other),
                          renderPostDetailButtonSection(
                            product.id,
                            product.createdBy,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row renderPostDetailButtonSection(String postId, String postCreatedBy) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        goToChatDetailButton(postCreatedBy),
        if (currentUser!.id == postCreatedBy) deletePostButton(postId),
      ],
    );
  }

  SizedBox goToChatDetailButton(String postCreatedBy) {
    return SizedBox(
      height: 50,
      width: currentUser!.id == postCreatedBy
          ? MediaQuery.of(context).size.width * 0.42
          : MediaQuery.of(context).size.width * 0.85,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            ChatListPage.routeName,
          );
        },
        child: const Text('Send Message'),
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
    );
  }

  deletePostButton(String postId) {
    return BlocBuilder<DeleteProductByIdCubit, DeleteProductByIdState>(
      builder: (context, state) {
        if (state is DeleteProductLoading) {
          return SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.42,
            child: const CircularProgressIndicator(),
          );
        }
        if (state is DeleteProductLoaded) {
          naviagateToMasterPage(context);
        }
        return SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.42,
          child: ElevatedButton(
            onPressed: () {
              context.read<DeleteProductByIdCubit>().call(postId, authToken!);
            },
            child: const Text('Delete Post'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
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
        );
      },
    );
  }

  void naviagateToMasterPage(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(
        context,
        MasterPage.routeName,
      );
    });
  }

  buildOtherInformation(Map<String, dynamic>? other) {
    List<Widget> otherInformation = [];
    if (other == null) return Container();

    other.forEach(
      (key, value) => otherInformation.add(
        PostDetailInformationItem(
          informationKey: key,
          informationValue: value,
        ),
      ),
    );

    return Column(
      children: [...otherInformation],
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
}
