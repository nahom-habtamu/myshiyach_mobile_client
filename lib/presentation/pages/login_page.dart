import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login/login_request_model.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../widgets/auth_input.dart';
import 'home_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/loginPage";
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName = "";
  String password = "";
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: renderBody(),
      ),
    );
  }

  renderBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            renderLoginPageHeaders(),
            const SizedBox(
              height: 55,
            ),
            AuthInput(
              hintText: "Phone Number",
              onChanged: (value) => setState(() => userName = value),
            ),
            const SizedBox(
              height: 25,
            ),
            AuthInput(
              obsecureText: true,
              hintText: "Password",
              onChanged: (value) => setState(() => password = value),
            ),
            const SizedBox(
              height: 20,
            ),
            renderRememberMeAndForgotPassword(),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return renderLoginButton();
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: renderLoginResult(),
            ),
            const SizedBox(
              height: 20,
            ),
            renderPageSwitcher()
          ],
        ),
      ),
    );
  }

  Row renderRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            renderCheckBox(),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Remember Me',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const Text(
          'Forgot Password ?',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff11435E),
          ),
        ),
      ],
    );
  }

  SizedBox renderCheckBox() {
    return SizedBox(
      width: 15,
      height: 25,
      child: Transform.scale(
        scale: 0.75,
        child: Checkbox(
          value: rememberMe,
          onChanged: (value) {
            setState(() {
              rememberMe = value!;
            });
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          tristate: false,
          activeColor: const Color(0xff11435E),
        ),
      ),
    );
  }

  BlocBuilder<AuthCubit, AuthState> renderLoginResult() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Loaded) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              HomePage.routeName,
            );
          });
          return Container();
        } else if (state is Error) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return const Text('EMPTY');
        }
      },
    );
  }

  Column renderLoginPageHeaders() {
    return Column(
      children: const [
        Text(
          "Let's Start Shopping",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Login to start using the app',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  renderPageSwitcher() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, SignUpPage.routeName);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Don't have an account ? ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
                TextSpan(
                  text: ' Sign Up ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff11435E),
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox renderLoginButton() {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          var requestBody = LoginRequestModel(
            userName: userName,
            password: password,
          );
          context.read<AuthCubit>().loginUser(requestBody);
        },
        child: const Text('Login'),
        style: ElevatedButton.styleFrom(
          primary: const Color(0xff11435E),
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
