import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authenticate_phone_number/authenticate_phone_number.cubit.dart';
import '../bloc/authenticate_phone_number/authenticate_phone_number_state.dart';
import '../widgets/auth_input.dart';
import '../widgets/common/curved_button.dart';
import '../widgets/common/verify_phone_number_button.dart';
import 'change_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  static String routeName = '/forgotPasswordPage';
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String phoneNumber = '';
  final formKey = GlobalKey<FormState>();

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              renderForgotPasswordPageHeaders(),
              const SizedBox(
                height: 55,
              ),
              AuthInput(
                hintText: "Phone Number",
                onChanged: (value) => setState(() => phoneNumber = value),
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
                height: 30,
              ),
              VerifyPhoneNumberButton(
                onVerifyClicked: () {
                  return formKey.currentState!.validate();
                },
                phoneNumber: phoneNumber,
                renderActionButton: renderforgotPasswordButton,
                renderErrorWidget: renderForgotError,
              )
            ],
          ),
        ),
      ),
    );
  }

  Column renderForgotPasswordPageHeaders() {
    return Column(
      children: const [
        Text(
          "Forgot Your Password ?",
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
          'Type Your Phone Number To Start',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  renderforgotPasswordButton(String pin, String verificationId) {
    return BlocBuilder<AuthPhoneNumberCubit, AuthPhoneNumberState>(
        builder: (context, state) {
      if (state is AuthPhoneNumberLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is AuthPhoneNumberSuccessfull) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            ChangePasswordPage.routeName,
            arguments: phoneNumber,
          );
        });
      }

      return CurvedButton(
        onPressed: () {
          var credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: pin,
          );
          context.read<AuthPhoneNumberCubit>().call(credential);
        },
        text: 'Submit',
      );
    });
  }

  renderForgotError() {
    return BlocBuilder<AuthPhoneNumberCubit, AuthPhoneNumberState>(
      builder: (context, state) {
        if (state is AuthPhoneNumberError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }

  renderActionButton(String pin, String verificationId) {}
}