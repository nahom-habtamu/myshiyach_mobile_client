import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../../data/models/login_request_model.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: renderBody(),
      ),
    );
  }

  BlocProvider<AuthCubit> renderBody() {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Let's Start shopping"),
            const Text('Login to start using the app'),
            const TextField(
              decoration: InputDecoration(
                hintText: "Phone Number",
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Loading) {
                  return const CircularProgressIndicator();
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().loginUser(
                            const LoginRequestModel(
                              userName: "nahomchangedagain",
                              password: "1205684",
                            ),
                          );
                    },
                    child: const Text('Login'),
                  );
                }
              },
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Loaded) {
                  return const Text('SUCCESSFULL');
                } else if (state is Error) {
                  return Text(state.message);
                } else {
                  return const Text('EMPTY');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
