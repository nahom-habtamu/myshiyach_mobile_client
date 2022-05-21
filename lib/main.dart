import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/injection_container.dart' as di;
import 'core/services/injection_container.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/get_all_products/get_all_products_cubit.dart';
import 'presentation/bloc/register_user/register_user_cubit.dart';
import 'presentation/bloc/verify_phone_number/verify_phone_number_cubit.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/intro_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/master_page.dart';
import 'presentation/pages/otp_verification_page.dart';
import 'presentation/pages/sign_up_page.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ),
        BlocProvider(
          create: (_) => sl<VerifyPhoneNumberCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<RegisterUserCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetAllProductsCubit>(),
        ),
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
          HomePage.routeName: (context) => const HomePage(),
          IntroPage.routeName: (context) => const IntroPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
          MasterPage.routeName: (context) => const MasterPage(),
          OtpVerificationPage.routeName: (context) =>
              const OtpVerificationPage(),
        },
      ),
    );
  }
}
