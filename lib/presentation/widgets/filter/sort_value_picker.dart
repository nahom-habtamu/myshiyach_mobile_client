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
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 40,
                child: ListTile(
                  title: const Text(
                    "Ascending",
                    style: TextStyle(fontSize: 13),
                  ),
                  leading: Radio(
                    value: true,
                    groupValue: selectedSortValue,
                    onChanged: (value) {
                      setState(() => selectedSortValue = value as bool);
                      widget.onSortingCriteriaChanged(selectedSortValue);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: const Text(
                    "Descending",
                    style: TextStyle(fontSize: 13),
                  ),
                  leading: Radio(
                    value: false,
                    groupValue: selectedSortValue,
                    onChanged: (value) {
                      setState(() => selectedSortValue = value as bool);
                      widget.onSortingCriteriaChanged(selectedSortValue);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
