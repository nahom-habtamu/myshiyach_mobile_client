import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/register_user/register_user_cubit.dart';
import '../../bloc/register_user/register_user_state.dart';
import '../../pages/login_page.dart';
import '../../screen_arguments/sign_up_button_arguments.dart';
import '../common/action_button.dart';

class SignUpButton extends StatelessWidget {
  final SignUpButtonArguments args;
  const SignUpButton({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterUserCubit, RegisterUserState>(
      builder: (context, state) {
        if (state is RegisterUserSuccessfull) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              LoginPage.routeName,
            );
          });
        }
        if (state is RegisterUserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ActionButton(
            onPressed: () {
              var credential = PhoneAuthProvider.credential(
                verificationId: args.verificationId,
                smsCode: args.pin,
              );
              context.read<RegisterUserCubit>().signUpUser(
                    args.registerUserRequest,
                    credential,
                  );
            },
            text: AppLocalizations.of(context).signUpText,
          );
        }
      },
    );
  }
}
