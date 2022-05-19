import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register_user/register_user_cubit.dart';
import '../bloc/register_user/register_user_state.dart';
import '../screen_arguments/otp_verification_page_argument.dart';
import '../widgets/otp_input.dart';

class OtpVerificationPage extends StatefulWidget {
  static String routeName = "/otpVerificationScreen";
  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String pin = "";
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as OtpVerficationPageArgument;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "An Authentecation code has been sent to",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                args.registerUserRequest.phoneNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff11435E),
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              OtpInput(onChanged: (value) => setState(() => pin = value)),
              const SizedBox(
                height: 30,
              ),
              BlocBuilder<RegisterUserCubit, RegisterUserState>(
                builder: (context, state) {
                  print(state);

                  if (state is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          var credential = PhoneAuthProvider.credential(
                            verificationId: args.phoneNumberVerificationId,
                            smsCode: pin,
                          );
                          context
                              .read<RegisterUserCubit>()
                              .signUpUser(args.registerUserRequest, credential);
                        },
                        child: const Text('Submit'),
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
              BlocBuilder<RegisterUserCubit, RegisterUserState>(
                builder: (context, state) {
                  if (state is Error) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
