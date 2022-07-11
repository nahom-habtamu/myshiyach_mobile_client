import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login/login_request_model.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../widgets/auth_input.dart';
import '../widgets/common/action_button.dart';
import 'forgot_password_page.dart';
import 'master_page.dart';
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
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().clear();
  }

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
        child: Form(
          key: formKey,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter PhoneNumber";
                  } else if (value.length < 10) {
                    return "Please Enter Correct Phone Number";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              AuthInput(
                obsecureText: true,
                hintText: "Password",
                onChanged: (value) => setState(() => password = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Password";
                  } else if (value.length < 6) {
                    return "Please Enter 6 or more characters";
                  }
                  return null;
                },
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
                  if (state is AuthLoading) {
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
      ),
    );
  }

  Row renderRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ForgotPasswordPage.routeName,
            );
          },
          child: const Text(
            'Forgot Password ?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff11435E),
            ),
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
        if (state is AuthSuccessfull) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              MasterPage.routeName,
            );
          });
          return Container();
        } else if (state is AuthError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return Container();
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

  ActionButton renderLoginButton() {
    return ActionButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          var requestBody = LoginRequestModel(
            userName: userName,
            password: password,
          );
          context.read<AuthCubit>().loginUser(requestBody);
        }
      },
      text: 'Login',
    );
  }
}
