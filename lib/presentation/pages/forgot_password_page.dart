import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/authenticate_phone_number/authenticate_phone_number.cubit.dart';
import '../bloc/authenticate_phone_number/authenticate_phone_number_state.dart';
import '../widgets/common/action_button.dart';
import '../widgets/common/phone_number_input.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AuthPhoneNumberCubit>().clear();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              renderForgotPasswordPageHeaders(),
              const SizedBox(
                height: 55,
              ),
              PhoneNumberInput(
                onChanged: (value) => setState(() => phoneNumber = value),
              ),
              const SizedBox(
                height: 30,
              ),
              VerifyPhoneNumberButton(
                isActive: true,
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
      children: [
        Text(
          AppLocalizations.of(context).forgotPassowordHeaderOne,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          AppLocalizations.of(context).forgotPassowordHeaderTwo,
          style: const TextStyle(
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
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            ChangePasswordPage.routeName,
            arguments: phoneNumber,
          );
        });
      }

      return ActionButton(
        onPressed: () {
          var credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: pin,
          );
          context.read<AuthPhoneNumberCubit>().call(credential);
        },
        text: AppLocalizations.of(context).forgotPasswordOtpVerifyButtonText,
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
