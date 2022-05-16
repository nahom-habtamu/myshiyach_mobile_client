import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/injection_container.dart' as di;
import 'core/services/injection_container.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/intro_page.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/sign_up_page.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthCubit>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color(0xff11435E),
          fontFamily: 'DMSans',
        ),
        home: const SplashPage(),
        routes: {
          SplashPage.routeName: (context) => const SplashPage(),
          IntroPage.routeName: (context) => const IntroPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
        },
      ),
    );
  }
}
