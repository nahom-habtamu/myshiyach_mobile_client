import 'package:flutter/material.dart';

class AddPostDropDownInput extends StatefulWidget {
  final String hintText;
  final List<Map<String, String>> items;
  final Function onChanged;
  final String initialValue;
  const AddPostDropDownInput({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.initialValue = "",
  }) : super(key: key);

  @override
  State<AddPostDropDownInput> createState() => _AddPostDropDownInputState();
}

class _AddPostDropDownInputState extends State<AddPostDropDownInput> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.isNotEmpty) selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DropdownButtonFormField(
        value: selectedValue,
        items: widget.items.map((item) {
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
        onChanged: (value) {
          setState(() {
            selectedValue = value.toString();
          });
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          labelText: widget.hintText,
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
