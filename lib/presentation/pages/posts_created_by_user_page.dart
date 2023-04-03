import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/filter/filter_criteria_model.dart';
import '../../data/models/product/page_and_limit_model.dart';
import '../../data/models/product/product_model.dart';
import '../../domain/enitites/product.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/display_all_products/display_all_products_cubit.dart';
import '../bloc/display_all_products/display_all_products_state.dart';
import '../bloc/get_user_by_id/get_user_by_id_cubit.dart';
import '../bloc/get_user_by_id/get_user_by_id_state.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../bloc/report_user/report_user_cubit.dart';
import '../bloc/update_favorite_products/update_favorite_products_cubit.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/empty_state_content.dart';
import '../widgets/common/error_content.dart';
import '../widgets/common/no_network_content.dart';
import '../widgets/common/profile_avatar_and_data.dart';
import '../widgets/home/product_grid_with_pagination.dart';
import '../widgets/post_detail/send_message_button.dart';
import 'add_post_page.dart';

class PostsCreatedByUserPage extends StatefulWidget {
  static String routeName = '/postsCreatedByUserPage';
  const PostsCreatedByUserPage({Key? key}) : super(key: key);

  @override
  State<PostsCreatedByUserPage> createState() => _PostsCreatedByUserPageState();
}

class _PostsCreatedByUserPageState extends State<PostsCreatedByUserPage> {
  String accessToken = "";
  User? currentUser;
  User? strangerUser;
  String userId = "";
  List<String> favorites = [];
  List<Product> productsToDisplay = [];
  PageAndLimitModel? pageAndLimit = PageAndLimitModel.initialDefault();

  @override
  void initState() {
    super.initState();
    initAccessToken();
    context.read<HandleGoingToMessageCubit>().clear();
    Future.delayed(Duration.zero, () {
      userId = ModalRoute.of(context)!.settings.arguments as String;
      initializeUser(userId);
      fetchPostsCreatedByUser(userId);
    });
  }

  void initAccessToken() {
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      accessToken = authState.loginResult.token;
      currentUser = authState.currentUser;
    }
  }

  void fetchPostsCreatedByUser(String userId) {
    context.read<DisplayAllProductsCubit>().call(
          PageAndLimitModel.initialDefault(),
          FilterCriteriaModel.empty(createdBy: userId),
          accessToken,
          currentUser?.id ?? "",
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).postsCreatedByUserPageAppBarText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff11435E),
          elevation: 0,
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                context.read<ReportUserCubit>().call(userId, accessToken);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                          .postsCreatedByUserPageReportUserSuccessText,
                    ),
                    backgroundColor: Colors.deepOrange,
                  ),
                );
              },
              itemBuilder: (BuildContext context) {
                var contentToShowOnPopup = [
                  AppLocalizations.of(context).postDetailReportText,
                ];
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
            )
          ]),
      body: CurvedContainer(
        child: renderBody(),
      ),
    );
  }

  void updateState(Loaded state) {
    var updatedProductList = [
      ...productsToDisplay,
      ...state.paginatedResult.products
    ];
    setState(() {
      productsToDisplay = updatedProductList;
      favorites = [...state.favorites];
      pageAndLimit =
          PageAndLimitModel.fromPaginationLimit(state.paginatedResult.next);
    });
  }

  buildEmptyStateContent() {
    return Center(
      child: FallBackContent(
        captionText:
            AppLocalizations.of(context).postsCreatedByUserPageEmptyCaptionText,
        hintText:
            AppLocalizations.of(context).postsCreatedByUserPageEmptyHintText,
        buttonText:
            AppLocalizations.of(context).postsCreatedByUserPageEmptyButtonText,
        onButtonClicked: () {
          Navigator.pushReplacementNamed(context, AddPostPage.routeName);
        },
      ),
    );
  }

  buildNoNetworkContent() {
    return Center(
      child: NoNetworkContent(
        onButtonClicked: () => fetchPostsCreatedByUser(userId),
      ),
    );
  }

  buildErrorContent() {
    return Center(
      child: ErrorContent(
        onButtonClicked: () => fetchPostsCreatedByUser(userId),
      ),
    );
  }

  renderBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 142,
          child: displayUserTab(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SendMessageButton(
            currentUser: currentUser!,
            receiverId: userId,
            authToken: accessToken,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9 - 210,
          child: displayProducts(),
        ),
      ],
    );
  }

  BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>
      displayProducts() {
    return BlocBuilder<DisplayAllProductsCubit, DisplayAllProductsState>(
      builder: (context, state) {
        if (state is Loaded) {
          SchedulerBinding.instance.addPostFrameCallback(
            ((timeStamp) {
              updateState(state);
              context.read<DisplayAllProductsCubit>().clear();
            }),
          );
        } else if (state is Loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is Error) {
          return buildErrorContent();
        } else if (state is NoNetwork) {
          return buildNoNetworkContent();
        }
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ProductGridWithPagination(
            filterValues: FilterCriteriaModel.empty(createdBy: userId),
            products: productsToDisplay,
            favorites: favorites,
            pageAndLimit: pageAndLimit,
            onRefreshed: updateStateOnRefresh,
          ),
        );
      },
    );
  }

  Widget displayUserTab() {
    if (strangerUser != null) {
      return ProfileAvatarAndData(user: strangerUser);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  updateStateOnRefresh(newState, updatedFavorites) {
    var productsToAddInState = List<ProductModel>.from(newState.result.products)
        .where((p) => productsToDisplay.where((pis) => pis.id == p.id).isEmpty)
        .toList();

    setState(() {
      productsToDisplay = [...productsToDisplay, ...productsToAddInState];
      favorites = [...updatedFavorites];
      pageAndLimit = newState.result.products.isNotEmpty
          ? PageAndLimitModel.fromPaginationLimit(newState.result.next)
          : null;
    });
  }

  void updateFavorites(
    List<Product> duplicate,
    Product product,
  ) {
    if (duplicate.isNotEmpty) {
      favorites.removeWhere((element) => element == product.id);
      setState(() {});
    } else {
      setState(() {
        favorites = [product.id, ...favorites];
      });
    }
    context
        .read<UpdateFavoriteProductsCubit>()
        .updateFavoriteProducts
        .call(currentUser!.id, accessToken, favorites);
  }

  void initializeUser(String userId) async {
    if (context.read<GetUserByIdCubit>().state is! GetUserByIdLoaded) {
      var stranger =
          await context.read<GetUserByIdCubit>().call(userId, accessToken);
      setState(() {
        strangerUser = stranger;
      });
    }
  }
}
