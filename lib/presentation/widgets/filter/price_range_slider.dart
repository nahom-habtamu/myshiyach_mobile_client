import 'package:flutter/material.dart';

class PriceRangeSlider extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final Function onChanged;
  const PriceRangeSlider({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  RangeValues _currentRangeValues = const RangeValues(0, 1);

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(widget.minValue, widget.maxValue);
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      max: widget.maxValue,
      min: widget.minValue,
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
        widget.onChanged(_currentRangeValues);
      },
    );
  }
}
