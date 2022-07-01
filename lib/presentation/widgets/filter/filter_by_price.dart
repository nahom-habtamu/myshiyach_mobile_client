import 'package:flutter/material.dart';

import 'price_range_slider.dart';

class FilterByPrice extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final Function onChanged;
  const FilterByPrice({
    Key? key,
    required this.onChanged,
    required this.minValue,
    required this.maxValue,
  }) : super(key: key);

  @override
  State<FilterByPrice> createState() => _FilterByPriceState();
}

class _FilterByPriceState extends State<FilterByPrice> {
  var _currentRangeValues = const RangeValues(0, 0);

  double minPriceFromDialog = 0.0;
  double maxPriceFromDialog = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
      widget.minValue,
      widget.maxValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Price Range',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.minValue.toInt()}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '\$${widget.maxValue.toInt()}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          PriceRangeSlider(
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            onChanged: (value) {
              setState(() {
                _currentRangeValues = value;
              });
              widget.onChanged(_currentRangeValues);
            },
          ),
          // PriceRangePickerDialog(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

