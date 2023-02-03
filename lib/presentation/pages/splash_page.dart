import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../domain/enitites/login_result.dart';
import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/get_paginated_products/get_is_app_opened_first_time_cubit.dart';
import '../bloc/get_product_by_id/get_product_by_id_cubit.dart';
import '../screen_arguments/post_detail_page_arguments.dart';
import '../widgets/common/no_network_content.dart';
import 'intro_page.dart';
import 'login_page.dart';
import 'master_page.dart';
import 'post_detail_page.dart';

class SplashPage extends StatefulWidget {
  static String routeName = "/splashPage";
  final PendingDynamicLinkData? linkData;
  const SplashPage({Key? key, this.linkData}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppUpdateInfo? _updateInfo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Platform messages are asynchronous, so we initialize in an async method.
  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void performImmediateUpdate() async {
    if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.performImmediateUpdate();
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      performImmediateUpdate();
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    context.read<AuthCubit>().loginUser(null);
  }

  @override
  Widget build(BuildContext context) {
    print(_updateInfo);
    return Scaffold(
      body: renderBody(),
    );
  }

  BlocBuilder<AuthCubit, AuthState> renderBody() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccessfull) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            handleSuccessCase(context, state.currentUser, state.loginResult);
          });
        }
        if (state is AuthError) {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            var isAppOpenedFirstTime =
                await context.read<GetIsAppOpenedFirstTimeCubit>().execute();
            if (isAppOpenedFirstTime) {
              Navigator.pushReplacementNamed(context, IntroPage.routeName);
            } else {
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            }
          });
        }
        if (state is AuthNoNetwork) {
          return renderNoNetwork();
        }
        return renderAppTitle();
      },
    );
  }

  handleSuccessCase(
    BuildContext context,
    User currentUser,
    LoginResult loginResult,
  ) {
    if (widget.linkData == null) {
      navigateToMasterPage(context);
    } else {
      handleFetchingProductAndNavigateToProductDetail(currentUser, loginResult);
    }
  }

  void navigateToMasterPage(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      MasterPage.routeName,
    );
  }

  Center renderAppTitle() {
    return Center(
      child: Text(
        AppLocalizations.of(context).appTitle,
        style: const TextStyle(
          color: Color(0xFF11435E),
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  renderNoNetwork() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: NoNetworkContent(
        onButtonClicked: () => context.read<AuthCubit>().loginUser(null),
      ),
    );
  }

  void handleFetchingProductAndNavigateToProductDetail(
    User currentUser,
    LoginResult loginResult,
  ) async {
    var productId = widget.linkData!.link.queryParameters["productId"];
    var product = await context
        .read<GetProductByIdCubit>()
        .call(productId!, loginResult.token);

    if (product != null) {
      Navigator.pushReplacementNamed(
        context,
        PostDetailPage.routeName,
        arguments: PostDetalPageArguments(
          product: product,
          isFromDynamicLink: true,
          currentUser: currentUser,
          token: loginResult.token,
        ),
      );
    }
  }
}
