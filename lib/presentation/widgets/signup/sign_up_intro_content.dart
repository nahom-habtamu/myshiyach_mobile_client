import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpIntroContent extends StatelessWidget {
  const SignUpIntroContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Text(
              AppLocalizations.of(context).signUpPageRegisterText,
              style: const TextStyle(
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
          Text(
            AppLocalizations.of(context).signUpPageHeaderOne,
            style: const TextStyle(
              color: Color(0xff11435E),
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context).signUpPageHeaderTwo,
            style: const TextStyle(
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
