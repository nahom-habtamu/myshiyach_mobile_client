import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/login_page_constants.dart';

class PhoneNumberInput extends StatefulWidget {
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  const PhoneNumberInput({
    Key? key,
    required this.onChanged,
    this.onSubmitted,
    this.focusNode,
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
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.next,
      onSubmitted: widget.onSubmitted,
      onChanged: (phone) => widget.onChanged(phone.completeNumber),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).loginPhoneNumberHint,
        border: loginInputEnabledBorder,
        enabledBorder: loginInputEnabledBorder,
        focusedBorder: loginInputDisabledBorder,
        isDense: true,
        contentPadding: const EdgeInsets.all(18),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
