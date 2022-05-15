import 'package:flutter/material.dart';

import '../constants/login_page_constants.dart';

class AuthInput extends StatelessWidget {
  final bool obsecureText;
  final String hintText;
  final Function(String) onChanged;
  const AuthInput({
    Key? key,
    this.obsecureText = false,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText,
      style: loginInputTextStyle,
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
        labelText: hintText,
        border: loginInputEnabledBorder,
        enabledBorder: loginInputEnabledBorder,
        focusedBorder: loginInputDisabledBorder,
        suffixIcon: obsecureText
            ? InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.remove_red_eye,
                  size: 25,
                  color: Colors.grey,
                ),
              )
            : null,
        isDense: true,
        contentPadding: const EdgeInsets.all(18),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
