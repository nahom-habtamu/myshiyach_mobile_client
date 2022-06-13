import 'package:flutter/material.dart';

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
