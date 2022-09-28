import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/change_password/change_password_cubit.dart';
import '../bloc/change_password/change_password_state.dart';
import '../constants/login_page_constants.dart';
import '../utils/show_toast.dart';
import '../widgets/auth_input.dart';
import '../widgets/common/action_button.dart';
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

  var passwordRepeatFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    clearChangePasswordState();
    initalizePhoneNumberFromArgument();
  }

  @override
  void dispose() {
    super.dispose();
    passwordRepeatFocusNode.dispose();
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
                hintText: AppLocalizations.of(context).changePasswordInputHint,
                onChanged: (value) => password = value,
                onSubmitted: (value) => passwordRepeatFocusNode.requestFocus(),
                obsecureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                        .changePasswordInputValidationEmptyText;
                  } else if (value.length < passwordInputMinLength) {
                    return AppLocalizations.of(context)
                        .changePasswordInputValidationTooShortText;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              AuthInput(
                hintText:
                    AppLocalizations.of(context).changePasswordRepeatInputHint,
                onChanged: (value) => password = value,
                obsecureText: true,
                focusNode: passwordRepeatFocusNode,
                onSubmitted: (value) => handleSubmission(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                        .changePasswordInputValidationEmptyText;
                  } else if (value.length < passwordInputMinLength) {
                    return AppLocalizations.of(context)
                        .changePasswordInputValidationTooShortText;
                  } else if (value != password) {
                    return AppLocalizations.of(context)
                        .changePasswordInputValidationNotMatchText;
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
        if (state is ChangePasswordError) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            showToast(
              context,
              AppLocalizations.of(context).changePasswordErrorText,
            );
          });
        }
        if (state is ChangePasswordSuccessfull) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              LoginPage.routeName,
            );
          });
        }
        return ActionButton(
          onPressed: () {
            handleSubmission();
          },
          text: AppLocalizations.of(context).changePasswordButtonText,
        );
      },
    );
  }

  void handleSubmission() {
    if (formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().call(phoneNumber, password);
    }
  }

  Column renderChangePasswordPageHeaders() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).changePasswordIntroHeaderOne,
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
          AppLocalizations.of(context).changePasswordIntroHeaderTwo,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
