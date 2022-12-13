import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/login/login_request_model.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/change_password/change_password_cubit.dart';
import '../bloc/set_is_app_opened_first_time/set_is_app_opened_first_time_cubit.dart';
import '../utils/show_toast.dart';
import '../widgets/auth_input.dart';
import '../widgets/common/action_button.dart';
import '../widgets/common/phone_number_input.dart';
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
  final formKey = GlobalKey<FormState>();

  var passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().clear();
    context.read<SetIsAppOpenedFirstTimeCubit>().execute();
    context.read<ChangePasswordCubit>().clear();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
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
          child: FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
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
                PhoneNumberInput(
                  onChanged: (value) => setState(() => userName = value),
                  onSubmitted: (_) {
                    passwordFocusNode.requestFocus();
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                AuthInput(
                  focusNode: passwordFocusNode,
                  onSubmitted: (_) => handleLogin(),
                  obsecureText: true,
                  hintText: AppLocalizations.of(context).loginPasswordHint,
                  onChanged: (value) => setState(() => password = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                          .loginPasswordEmptyError;
                    } else if (value.length < 4) {
                      return AppLocalizations.of(context)
                          .loginPasswordTooShortError;
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
          child: Text(
            AppLocalizations.of(context).loginForgotPasswordText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff11435E),
            ),
          ),
        ),
      ],
    );
  }

  BlocBuilder<AuthCubit, AuthState> renderLoginResult() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthNoNetwork) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            showToast(
              context,
              AppLocalizations.of(context).commonFallBackNoNetworkCaptionText,
            );
          });
        }
        if (state is AuthSuccessfull) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
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
      children: [
        Text(
          AppLocalizations.of(context).loginPageHeaderOne,
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
          AppLocalizations.of(context).loginPageHeaderTwo,
          style: const TextStyle(
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
        child: Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context).loginDontHaveAccountText,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).loginSignUpText,
                  style: const TextStyle(
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
        handleLogin();
      },
      text: AppLocalizations.of(context).loginButtonText,
    );
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      var requestBody = LoginRequestModel(
        userName: userName,
        password: password,
      );
      context.read<AuthCubit>().loginUser(requestBody);
    }
  }
}
