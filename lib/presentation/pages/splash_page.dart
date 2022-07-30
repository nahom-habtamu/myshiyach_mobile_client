import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../widgets/common/empty_state_content.dart';
import 'intro_page.dart';
import 'master_page.dart';

class SplashPage extends StatefulWidget {
  static String routeName = "/splashPage";
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().loginUser(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderBody(),
    );
  }

  BlocBuilder<AuthCubit, AuthState> renderBody() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccessfull) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              MasterPage.routeName,
            );
          });
        }
        if (state is AuthError) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              IntroPage.routeName,
            );
          });
        }

        if (state is AuthNoNetwork) {
          return renderNoNetwork();
        }
        return renderAppTitle();
      },
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
      child: EmptyStateContent(
        captionText: "No Network",
        onButtonClicked: () {
          context.read<AuthCubit>().loginUser(null);
        },
        hintText: "Please Connect to network to keep using the application",
        buttonText: "Retry",
      ),
    );
  }
}
