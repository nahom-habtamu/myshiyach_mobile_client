import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                child: Text(
                  AppLocalizations.of(context).otpVerificationHeaderOne,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                AppLocalizations.of(context).otpVerificationHeaderTwo,
                style: const TextStyle(
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
