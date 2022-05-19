import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/presentation/screen_arguments/otp_verification_page_argument.dart';

import '../../data/models/register_user/register_user_request_model.dart';
import '../bloc/verify_phone_number/verify_phone_number_cubit.dart';
import '../bloc/verify_phone_number/verify_phone_number_state.dart';
import '../widgets/auth_input.dart';
import 'login_page.dart';
import 'otp_verification_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                renderIntroContent(context),
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
                ),
                const SizedBox(
                  height: 25,
                ),
                AuthInput(
                  hintText: "Phone Number",
                  onChanged: (value) => {
                    setState(() {
                      phoneNumber = value;
                    })
                  },
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
                    const Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                            text: "By creating an account, you agree to our\n",
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 0.2,
                            ),
                          ),
                          TextSpan(
                            text: 'Term and Conditions ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff11435E),
                              letterSpacing: 0.2,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<VerifyPhoneNumberCubit, VerifyPhoneNumberState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (state is CodeSent) {
                        var registerRequest = RegisterUserRequestModel(
                          fullName: fullName,
                          phoneNumber: phoneNumber,
                          password: password,
                        );

                        var otpPageArgument = OtpVerficationPageArgument(
                          registerRequest,
                          state.verificationId,
                        );

                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(
                            context,
                            OtpVerificationPage.routeName,
                            arguments: otpPageArgument,
                          );
                        });
                      }

                      return SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<VerifyPhoneNumberCubit>()
                                .verify(phoneNumber);
                          },
                          child: const Text('Continue'),
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
                  },
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
    );
  }

  renderIntroContent(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Register',
              style: TextStyle(
                color: Color(0xff11435E),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Getting Started',
            style: TextStyle(
              color: Color(0xff11435E),
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Seems you are new here,\nLet\'s set up your profile.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 22,
              height: 1.3,
              letterSpacing: 0.3,
            ),
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
