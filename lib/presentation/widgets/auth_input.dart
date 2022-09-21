import 'package:flutter/material.dart';

import '../constants/login_page_constants.dart';

class AuthInput extends StatefulWidget {
  final bool obsecureText;
  final String hintText;
  final Function(String) onChanged;
  final Function validator;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;

  const AuthInput({
    Key? key,
    this.obsecureText = false,
    required this.hintText,
    required this.onChanged,
    required this.validator,
    this.focusNode,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = widget.obsecureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      obscureText: isPasswordVisible,
      style: loginInputTextStyle,
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: widget.focusNode == null
          ? TextInputAction.done
          : TextInputAction.next,
      onChanged: (value) => widget.onChanged(value),
      validator: (value) => widget.validator(value),
      decoration: InputDecoration(
        labelText: widget.hintText,
        border: loginInputEnabledBorder,
        enabledBorder: loginInputEnabledBorder,
        focusedBorder: loginInputDisabledBorder,
        suffixIcon: widget.obsecureText
            ? InkWell(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
