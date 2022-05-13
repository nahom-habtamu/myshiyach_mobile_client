import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/injection_container.dart' as di;
import 'core/services/injection_container.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/screens/login_page.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const LoginPage(),
      ),
    );
  }
}
