import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/register_user/register_user_request_model.dart';
import '../bloc/register_user/register_user_cubit.dart';
import '../bloc/register_user/register_user_state.dart';
import '../screen_arguments/sign_up_button_arguments.dart';
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
                    hintText: "Full Name",
                    onChanged: (value) => {
                      setState(() {
                        fullName = value;
                      })
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter FullName";
                      } else if (value.length < 5) {
                        return "Please Enter Your Full Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  PhoneNumberInput(
                    onChanged: (value) => setState(() => phoneNumber = value),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthInput(
                    hintText: "Password",
                    onChanged: (value) => {
                      setState(() {
                        password = value;
                      })
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Password";
                      } else if (value.length < 6) {
                        return "Please Enter 6 or more characters";
                      }
                      return null;
                    },
                    obsecureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthInput(
                    hintText: "Confirm Password",
                    onChanged: (value) => {
                      setState(() {
                        passwordRepeat = value;
                      })
                    },
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
                          scale: 0.75,
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
                    onVerifyClicked: () {
                      return formKey.currentState!.validate();
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
                      child: const Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account ? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              TextSpan(
                                text: ' Sign In ',
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
        if (state is RegisterUserError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
