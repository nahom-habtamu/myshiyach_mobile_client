import 'package:flutter/material.dart';

class AddPostInput extends StatelessWidget {
  final Function onChanged;
  final String hintText;
  final dynamic initialValue;
  const AddPostInput({
    Key? key,
    required this.hintText, required this.onChanged, this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        initialValue: initialValue,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
        onChanged: (value) => onChanged(value),
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
          contentPadding: const EdgeInsets.all(15),
          filled: true,
          fillColor: Colors.white54,
        ),
      ),
    );
  }
}