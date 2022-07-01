import 'package:flutter/material.dart';

class SortValuePicker extends StatefulWidget {
  final String sortingCriteriaTitle;
  final Function(bool?) onSortingCriteriaChanged;
  final bool? initialValue;
  const SortValuePicker({
    Key? key,
    required this.sortingCriteriaTitle,
    required this.onSortingCriteriaChanged,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<SortValuePicker> createState() => _SortValuePickerState();
}

class _SortValuePickerState extends State<SortValuePicker> {
  bool? selectedSortValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedSortValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 1,
            color: Color(0xFFBEBEBE),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 5),
            child: Text(
              widget.sortingCriteriaTitle,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text("Order By Ascending"),
                leading: Radio(
                  value: true,
                  groupValue: selectedSortValue,
                  onChanged: (value) {
                    setState(() => selectedSortValue = value as bool);
                    widget.onSortingCriteriaChanged(selectedSortValue);
                  },
                ),
              ),
              ListTile(
                title: const Text("Order Descending"),
                leading: Radio(
                  value: false,
                  groupValue: selectedSortValue,
                  onChanged: (value) {
                    setState(() => selectedSortValue = value as bool);
                    widget.onSortingCriteriaChanged(selectedSortValue);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
