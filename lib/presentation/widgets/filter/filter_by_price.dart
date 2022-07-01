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
          MaterialButton(
            onPressed: () {
              _displayTextInputDialog();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Min Price = ${_currentRangeValues.start.toInt()}\$',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Max Price = ${_currentRangeValues.end.toInt()}\$',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Price Control'),
          content: SizedBox(
            height: 170,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      minPriceFromDialog = double.parse(value);
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Min Price",
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      maxPriceFromDialog = double.parse(value);
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Max Price",
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentRangeValues = RangeValues(
                        minPriceFromDialog,
                        maxPriceFromDialog,
                      );
                    });
                    widget.onChanged(_currentRangeValues);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
