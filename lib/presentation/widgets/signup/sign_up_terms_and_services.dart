import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpTermsAndServices extends StatelessWidget {
  const SignUpTermsAndServices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: 12),
        children: [
          TextSpan(
            text: AppLocalizations.of(context).signUpTermsAndConditionOne,
            style: const TextStyle(
              color: Colors.grey,
              letterSpacing: 0.2,
            ),
          ),
          TextSpan(
            text: AppLocalizations.of(context).signUpTermsAndConditionTwo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff11435E),
              letterSpacing: 0.2,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
