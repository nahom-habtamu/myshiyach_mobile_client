import 'package:flutter/material.dart';

import '../home/category_item.dart';

class SortValuePicker extends StatefulWidget {
  final String sortingCriteriaTitle;
  final Function(bool?) onSortingCriteriaChanged;
  const SortValuePicker({
    Key? key,
    required this.sortingCriteriaTitle,
    required this.onSortingCriteriaChanged,
  }) : super(key: key);

  @override
  State<SortValuePicker> createState() => _SortValuePickerState();
}

class _SortValuePickerState extends State<SortValuePicker> {
  int selectedSortValue = -1;
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
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              widget.sortingCriteriaTitle,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CategoryItem(
                category: "Descending",
                isActive: selectedSortValue == 0,
                onTap: () {
                  setState(() {
                    if (selectedSortValue == 0) {
                      selectedSortValue = -1;
                      widget.onSortingCriteriaChanged(null);
                    } else {
                      selectedSortValue = 0;
                      widget.onSortingCriteriaChanged(false);
                    }
                  });
                },
              ),
              CategoryItem(
                category: "Ascending",
                isActive: selectedSortValue == 1,
                onTap: () {
                  setState(() {
                    if (selectedSortValue == 1) {
                      selectedSortValue = -1;
                      widget.onSortingCriteriaChanged(null);
                    } else {
                      selectedSortValue = 1;
                      widget.onSortingCriteriaChanged(true);
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
