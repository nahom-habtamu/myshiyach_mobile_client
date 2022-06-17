import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/change_password/change_password_cubit.dart';
import '../bloc/change_password/change_password_state.dart';
import '../widgets/auth_input.dart';
import '../widgets/common/curved_button.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  static String routeName = '/changePasswordPage';
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String password = '';
  String passwordRepeat = '';
  String phoneNumber = '';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    clearChangePasswordState();
    initalizePhoneNumberFromArgument();
  }

  void clearChangePasswordState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<ChangePasswordCubit>().clear();
    });
  }

  void initalizePhoneNumberFromArgument() {
    Future.delayed(Duration.zero, () {
      setState(() {
        phoneNumber = ModalRoute.of(context)!.settings.arguments as String;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: renderBody(),
    );
  }

  renderBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              renderChangePasswordPageHeaders(),
              const SizedBox(
                height: 55,
              ),
              AuthInput(
                hintText: "Password",
                onChanged: (value) => password = value,
                obsecureText: true,
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
                height: 25,
              ),
              AuthInput(
                hintText: "Password Repeat",
                onChanged: (value) => password = value,
                obsecureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Password";
                  } else if (value.length < 6) {
                    return "Please Enter 6 or more characters";
                  } else if (value != password) {
                    return "Password Don't Match";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              renderChangePasswordButton()
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<ChangePasswordCubit, ChangePasswordState>
      renderChangePasswordButton() {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        if (state is ChangePasswordLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ChangePasswordSuccessfull) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              LoginPage.routeName,
            );
          });
        }
        return CurvedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<ChangePasswordCubit>().call(phoneNumber, password);
            }
          },
          text: 'Change Password',
        );
      },
    );
  }

  Column renderChangePasswordPageHeaders() {
    return Column(
      children: const [
        Text(
          "Change Your Password?",
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
          'Type in your new password here .',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
