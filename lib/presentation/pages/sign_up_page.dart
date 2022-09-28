import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/register_user/register_user_request_model.dart';
import '../bloc/register_user/register_user_cubit.dart';
import '../bloc/register_user/register_user_state.dart';
import '../constants/login_page_constants.dart';
import '../screen_arguments/sign_up_button_arguments.dart';
import '../utils/show_toast.dart';
import '../widgets/auth_input.dart';
import '../widgets/common/phone_number_input.dart';
import '../widgets/common/verify_phone_number_button.dart';
import '../widgets/signup/sign_up_button.dart';
import '../widgets/signup/sign_up_intro_content.dart';
import '../widgets/signup/sign_up_terms_and_services.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  static String routeName = "/signUpPage";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String fullName = "";
  String phoneNumber = "";
  String password = "";
  String passwordRepeat = "";
  bool areTermsAndConditionsAgreed = false;

  final formKey = GlobalKey<FormState>();
  var phoneNumberFocusNode = FocusNode();
  var passwordFocusNode = FocusNode();
  var passwordRepeatFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SignUpIntroContent(),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthInput(
                    onSubmitted: (_) => phoneNumberFocusNode.requestFocus(),
                    hintText: AppLocalizations.of(context).signUpFullNameHint,
                    onChanged: (value) => {
                      setState(() {
                        fullName = value;
                      })
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .signUpFullNameEmptyError;
                      } else if (value.length < 5) {
                        return AppLocalizations.of(context)
                            .signUpFullNameTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  PhoneNumberInput(
                    focusNode: phoneNumberFocusNode,
                    onSubmitted: (_) => passwordFocusNode.requestFocus(),
                    onChanged: (value) => setState(() => phoneNumber = value),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthInput(
                    focusNode: passwordFocusNode,
                    onSubmitted: (_) => passwordRepeatFocusNode.requestFocus(),
                    hintText: AppLocalizations.of(context).signUpPasswordHint,
                    onChanged: (value) => {
                      setState(() {
                        password = value;
                      })
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .signUpPasswordEmptyError;
                      } else if (value.length < passwordInputMinLength) {
                        return AppLocalizations.of(context)
                            .signUpPasswordTooShort;
                      }
                      return null;
                    },
                    obsecureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthInput(
                    focusNode: passwordRepeatFocusNode,
                    onSubmitted: (_) =>
                        setState(() => areTermsAndConditionsAgreed = true),
                    hintText: AppLocalizations.of(context).signUpPassRepeatHint,
                    onChanged: (value) => {
                      setState(() {
                        passwordRepeat = value;
                      })
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .signUpPassRepeatEmptyError;
                      } else if (value.length < passwordInputMinLength) {
                        return AppLocalizations.of(context)
                            .signUpPassRepeatTooShort;
                      } else if (value != password) {
                        return AppLocalizations.of(context)
                            .signUpPassRepeatNotMatch;
                      }
                      return null;
                    },
                    obsecureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                        height: 25,
                        child: Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            value: areTermsAndConditionsAgreed,
                            onChanged: (value) {
                              setState(() {
                                areTermsAndConditionsAgreed = value!;
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const SignUpTermsAndServices()
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  VerifyPhoneNumberButton(
                    isActive: areTermsAndConditionsAgreed,
                    onVerifyClicked: () {
                      return handleVerification(context);
                    },
                    phoneNumber: phoneNumber,
                    renderActionButton: renderRegisterButton,
                    renderErrorWidget: renderRegisterError,
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        LoginPage.routeName,
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .signUpAlreadyHaveAnAccount,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context).signInText,
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
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool handleVerification(BuildContext context) {
    if (areTermsAndConditionsAgreed) {
      return formKey.currentState!.validate();
    } else {
      showToast(
        context,
        AppLocalizations.of(context).signUpTermsAndConditionError,
      );
      return false;
    }
  }

  renderRegisterButton(String pin, String verificationId) {
    var registerUserRequest = RegisterUserRequestModel(
      fullName: fullName,
      password: password,
      phoneNumber: phoneNumber,
    );
    var args = SignUpButtonArguments(
      registerUserRequest: registerUserRequest,
      pin: pin,
      verificationId: verificationId,
    );
    return SignUpButton(
      args: args,
    );
  }

  BlocBuilder<RegisterUserCubit, RegisterUserState> renderRegisterError() {
    return BlocBuilder<RegisterUserCubit, RegisterUserState>(
      builder: (context, state) {
        if (state is RegisterUserNoNetwork) {
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            showToast(context, "No Network");
          });
        }
        if (state is RegisterUserError) {
          return Center(
            child: Text(AppLocalizations.of(context).signUpFailedErrorMessage),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
