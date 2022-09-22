import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  int selectedSortValue = -1;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedSortValue = parseBoolToSortValue();
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
      width: MediaQuery.of(context).size.width,
      child: ExpansionTile(
        title: Text(widget.sortingCriteriaTitle),
        trailing: const Text(
          '...',
          style: TextStyle(fontSize: 25),
        ),
        children: [
          SizedBox(
            height: 40,
            child: ListTile(
              title: Text(
                AppLocalizations.of(context).filterAscendingText,
                style: const TextStyle(fontSize: 13),
              ),
              leading: Radio(
                value: 0,
                groupValue: selectedSortValue,
                onChanged: (value) => handleValueChanged(value as int),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListTile(
              title: Text(
                AppLocalizations.of(context).filterDescendingText,
                style: const TextStyle(fontSize: 13),
              ),
              leading: Radio(
                value: 1,
                groupValue: selectedSortValue,
                onChanged: (value) => handleValueChanged(value as int),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  void handleValueChanged(int value) {
    setState(() => selectedSortValue = value);
    widget.onSortingCriteriaChanged(
      parseSortValueToBool(selectedSortValue),
    );
  }

  bool? parseSortValueToBool(int sortValue) {
    if (sortValue == -1) return null;
    if (sortValue == 1) return false;
    return true;
  }

  int parseBoolToSortValue() {
    if (widget.initialValue == null) return -1;
    if (widget.initialValue == true) return 0;

    return 1;
  }
}
