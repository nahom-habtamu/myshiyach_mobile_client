import 'package:flutter/material.dart';

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
                "An Authentication code has been sent to",
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
                args.phoneNumber,
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
              args.renderActionButton(pin, args.phoneNumberVerificationId),
              args.renderErrorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
