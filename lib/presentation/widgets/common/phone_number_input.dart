import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../constants/login_page_constants.dart';

class PhoneNumberInput extends StatefulWidget {
  final Function(String) onChanged;
  const PhoneNumberInput({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialCountryCode: "ET",
      style: loginInputTextStyle,
      onChanged: (phone) => widget.onChanged(phone.completeNumber),
      decoration: const InputDecoration(
        labelText: "Enter Phone",
        border: loginInputEnabledBorder,
        enabledBorder: loginInputEnabledBorder,
        focusedBorder: loginInputDisabledBorder,
        isDense: true,
        contentPadding: EdgeInsets.all(18),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
