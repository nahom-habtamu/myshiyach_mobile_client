import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInput extends StatefulWidget {
  final Function onChanged;
  const OtpInput({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 36,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 55,
        fieldWidth: 45,
        activeFillColor: Colors.white,
        inactiveColor: const Color(0xB31A5E83),
        disabledColor: Colors.white,
        inactiveFillColor: Colors.white,
        activeColor: const Color(0x7111435E),
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      onChanged: (value) {
        widget.onChanged(value);
      },
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
    );
  }
}
