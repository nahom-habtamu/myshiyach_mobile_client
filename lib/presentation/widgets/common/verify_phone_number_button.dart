import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/verify_phone_number/verify_phone_number_cubit.dart';
import '../../bloc/verify_phone_number/verify_phone_number_state.dart';
import '../../pages/otp_verification_page.dart';
import '../../screen_arguments/otp_verification_page_argument.dart';
import 'action_button.dart';

class VerifyPhoneNumberButton extends StatefulWidget {
  final String phoneNumber;
  final Function(String pin, String verificationId) renderActionButton;
  final Function renderErrorWidget;
  final Function onVerifyClicked;
  const VerifyPhoneNumberButton({
    Key? key,
    required this.phoneNumber,
    required this.renderActionButton,
    required this.renderErrorWidget,
    required this.onVerifyClicked,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberButton> createState() =>
      _VerifyPhoneNumberButtonState();
}

class _VerifyPhoneNumberButtonState extends State<VerifyPhoneNumberButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<VerifyPhoneNumberCubit>().clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyPhoneNumberCubit, VerifyPhoneNumberState>(
      builder: (context, state) {
        if (state is Error) {
          Fluttertoast.showToast(
            msg: "Phone Verification Failed",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFFA70606),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (state is CodeSent) {
            var otpPageArgument = OtpVerficationPageArgument(
              phoneNumber: widget.phoneNumber,
              phoneNumberVerificationId: state.verificationId,
              renderActionButton: widget.renderActionButton,
              renderErrorWidget: widget.renderErrorWidget,
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
          return ActionButton(
            onPressed: () {
              if (widget.onVerifyClicked()) {
                context
                    .read<VerifyPhoneNumberCubit>()
                    .verify(widget.phoneNumber);
              }
            },
            text: 'Continue',
          );
        }
      },
    );
  }
}
