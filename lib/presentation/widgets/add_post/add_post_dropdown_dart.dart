import 'package:flutter/material.dart';

import '../../../domain/enitites/main_category.dart';

class AddPostDropDownInput extends StatelessWidget {
  final String hintText;
  final List<Map<String,String>> items;
  final Function onChanged;
  const AddPostDropDownInput({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DropdownButtonFormField(
        items: items.map((item) {
          return DropdownMenuItem(
            value: item["value"],
            child: Text(
              item["preview"]!,
              style: const TextStyle(
                color: Color(0x893D3A3A),
              ),
            ),
          );
        }).toList(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
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