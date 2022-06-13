import 'package:flutter/material.dart';

class SignUpTermsAndServices extends StatelessWidget {
  const SignUpTermsAndServices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 12),
        children: [
          TextSpan(
            text: "By creating an account, you agree to our\n",
            style: TextStyle(
              color: Colors.grey,
              letterSpacing: 0.2,
            ),
          ),
          TextSpan(
            text: 'Term and Conditions ',
            style: TextStyle(
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
