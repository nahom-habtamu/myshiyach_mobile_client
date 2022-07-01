import 'package:flutter/material.dart';

class FilterDropDownInput extends StatefulWidget {
  final String hintText;
  final List<Map<String, String>> items;
  final Function onChanged;
  final String initialValue;
  final Function validator;
  const FilterDropDownInput({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.initialValue = "",
    required this.validator,
  }) : super(key: key);

  @override
  State<FilterDropDownInput> createState() => _FilterDropDownInputState();
}

class _FilterDropDownInputState extends State<FilterDropDownInput> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.isNotEmpty) selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: selectedValue,
      items: widget.items.map((item) {
        return DropdownMenuItem(
          value: item["value"],
          child: Text(
            item["preview"]!,
            style: const TextStyle(
              color: Color(0x893D3A3A),
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 13,
      ),
      onChanged: (value) {
        setState(() {
          selectedValue = value.toString();
        });
        widget.onChanged(value);
      },
      validator: (value) => widget.validator(value),
      decoration: InputDecoration(
        labelText: widget.hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
          borderSide: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
          borderSide: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
          borderSide: BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
