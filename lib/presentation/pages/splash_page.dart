import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
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

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // Future.delayed(
      //   const Duration(seconds: 1),
      //   () => {
      //     Navigator.pushReplacementNamed(
      //       context,
      //       IntroPage.routeName,
      //     )
      //   },
      // );
      context.read<AuthCubit>().loginUser(null, false);
    });
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
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              MasterPage.routeName,
            );
          });
        }
        if (state is AuthError) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              IntroPage.routeName,
            );
          });
        }
        return const Center(
          child: Text(
            'Men Ale',
            style: TextStyle(
              color: Color(0xFF11435E),
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
