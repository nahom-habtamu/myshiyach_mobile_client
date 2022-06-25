import 'package:flutter/material.dart';

import '../../../core/services/thousands_separator_input_formatter.dart';

class AddPostInput extends StatelessWidget {
  final Function onChanged;
  final Function validator;
  final String hintText;
  final dynamic initialValue;
  final bool isPrice;
  const AddPostInput({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.initialValue,
    required this.validator,
    this.isPrice = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      textAlign: TextAlign.center,
      onChanged: (value) => onChanged(value),
      validator: (value) => validator(value),
      inputFormatters: isPrice ? [ThousandsSeparatorInputFormatter()] : [],
      decoration: InputDecoration(
        labelText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
          borderSide: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
          borderSide: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
          borderSide: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(18),
        filled: true,
        fillColor: Colors.white54,
      ),
    );
  }
}
