import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/verify_phone_number/verify_phone_number_cubit.dart';
import '../../bloc/verify_phone_number/verify_phone_number_state.dart';
import '../../pages/otp_verification_page.dart';
import '../../screen_arguments/otp_verification_page_argument.dart';
import 'curved_button.dart';

class VerifyPhoneNumberButton extends StatelessWidget {
  final String phoneNumber;
  final Function(String pin, String verificationId) renderActionButton;
  final Function renderErrorWidget;
  const VerifyPhoneNumberButton({
    Key? key,
    required this.phoneNumber,
    required this.renderActionButton,
    required this.renderErrorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyPhoneNumberCubit, VerifyPhoneNumberState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (state is CodeSent) {
            var otpPageArgument = OtpVerficationPageArgument(
              phoneNumber: phoneNumber,
              phoneNumberVerificationId: state.verificationId,
              renderActionButton: renderActionButton,
              renderErrorWidget: renderErrorWidget,
            );

            SchedulerBinding.instance!.addPostFrameCallback(
              (_) {
                Navigator.pushReplacementNamed(
                  context,
                  OtpVerificationPage.routeName,
                  arguments: otpPageArgument,
                );
              },
            );
          }
          return CurvedButton(
            onPressed: () {
              context.read<VerifyPhoneNumberCubit>().verify(phoneNumber);
            },
            text: 'Continue',
          );
        }
      },
    );
  }
}
