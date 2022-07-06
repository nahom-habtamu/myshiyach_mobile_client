import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/date_time_formatter.dart';
import '../../core/utils/price_formatter.dart';
import '../../data/models/conversation/add_conversation_model.dart';
import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_state.dart';
import '../widgets/common/curved_button.dart';
import '../widgets/post_detail/post_detail_carousel.dart';
import '../widgets/post_detail/post_detail_information_item.dart';
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Visibility(
        visible: product != null,
        child: Scaffold(
          appBar: renderAppBar(),
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
                  items: [...product!.productImages],
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
                            renderTitle(),
                            const SizedBox(
                              height: 20,
                            ),
                            renderTimeContent(),
                            const SizedBox(
                              height: 10,
                            ),
                            renderPrice(),
                            const SizedBox(
                              height: 10,
                            ),
                            renderDescription(),
                            const SizedBox(
                              height: 10,
                            ),
                            renderCity(),
                            const SizedBox(
                              height: 10,
                            ),
                            renderOtherData(),
                            const SizedBox(
                              height: 10,
                            ),
                            renderPostDetailButtonSection(),
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
      ),
    );
  }

  SizedBox renderCity() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: PostDetailInformationItem(
        informationKey: "City",
        informationValue: product!.city,
      ),
    );
  }

  SizedBox renderDescription() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: PostDetailInformationItem(
        informationKey: "Description",
        informationValue: product!.description,
      ),
    );
  }

  Container renderPrice() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFDBD7D7),
        ),
      ),
      child: Text(
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
      ),
    );
  }

  Row renderTimeContent() {
    return Row(
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
          DateFormatterUtil.formatProductCreatedAtTime(
            product!.createdAt,
          ),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  renderOtherData() {
    return Column(
      children: [...buildOtherDetail()],
    );
  }

  buildOtherDetail() {
    if (product!.productDetail == null || product!.productDetail!.isEmpty) {
      return [];
    }
    return product!.productDetail!.entries
        .toList()
        .map(
          (e) => Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: PostDetailInformationItem(
                  informationKey: e.key,
                  informationValue: e.value,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        )
        .toList();
  }

  Container renderTitle() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFDBD7D7),
        ),
      ),
      child: Text(
        product!.title,
        style: const TextStyle(
          color: Color(0xff11435E),
          fontSize: 18,
          height: 1.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      title: const Text(
        'Post Detail',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: const Color(0xffF1F1F1),
      elevation: 0,
      centerTitle: true,
      actions: [
        if (currentUser!.id == product!.createdBy)
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                EditPostPage.routeName,
                arguments: product,
              );
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
          )
      ],
    );
  }

  Row renderPostDetailButtonSection() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      currentUser!.id != product!.createdBy
          ? goToChatDetailButton(product!.createdBy)
          : Container()
    ]);
  }

  BlocBuilder goToChatDetailButton(String postCreatedBy) {
    return BlocBuilder<HandleGoingToMessageCubit, HandleGoingToMessageState>(
        builder: (context, state) {
      if (state is HandleGoingToMessageLoading) {
        return const SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        );
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
      return CurvedButton(
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
      );
    });
  }

  void naviagateToMasterPage(BuildContext context) {
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
}
