import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'intro_page.dart';

import '../../core/services/injection_container.dart';
import '../bloc/auth_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(seconds: 1),
        () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => sl<AuthCubit>(),
                child: const IntroPage(),
              ),
            ),
          )
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Men Ale',
          style: TextStyle(
            color: Color(0xFF11435E),
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
