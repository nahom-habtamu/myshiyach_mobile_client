import 'package:flutter/material.dart';

class OtpVerificationPage extends StatelessWidget {
  static String routeName = "/otpVerificationScreen";
  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('I AM OTP VERIFICATION SCREEN'),
        ),
      ),
    );
  }
}
