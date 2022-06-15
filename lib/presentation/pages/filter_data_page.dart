import 'package:flutter/material.dart';

import '../../domain/enitites/main_category.dart';
import '../screen_arguments/filter_page_argument.dart';
import '../widgets/common/curved_button.dart';
import '../widgets/filter/price_range_slider.dart';
import '../widgets/home/category_item.dart';

class FilterDataPage extends StatefulWidget {
  static String routeName = '/filterDataPage';
  const FilterDataPage({Key? key}) : super(key: key);

  @override
  State<FilterDataPage> createState() => _FilterDataPageState();
}

class _FilterDataPageState extends State<FilterDataPage> {
  var _currentPriceRangeValues = const RangeValues(0, 0);
  List<MainCategory> selectedMainCategories = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentPriceRangeValues = const RangeValues(0, 0);
      selectedMainCategories = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as FilterPageArgument;
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      appBar: AppBar(
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffF1F1F1),
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            FilterByPrice(
              maxValue: args.maxValue,
              minValue: args.minValue,
              onChanged: (value) {
                setState(() {
                  _currentPriceRangeValues = value;
                });
              },
            ),
            const SizedBox(
              height: 25,
            ),
            FilterCategories(
              categories: [...args.categories],
              onSelectedCategoriesChanged: (value) {
                setState(() {
                  selectedMainCategories = [...value];
                });
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: CurvedButton(
                  onPressed: () {
                    var filterValues = FilterPageArgument(
                      categories: selectedMainCategories,
                      maxValue: _currentPriceRangeValues.end,
                      minValue: _currentPriceRangeValues.start,
                    );
                    Navigator.pop(context, filterValues);
                  },
                  text: "Apply Filter",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilterCategories extends StatefulWidget {
  final List<MainCategory> categories;
  final Function onSelectedCategoriesChanged;
  const FilterCategories({
    Key? key,
    required this.categories,
    required this.onSelectedCategoriesChanged,
  }) : super(key: key);

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
}

class _FilterCategoriesState extends State<FilterCategories> {
  List<MainCategory> selectedMainCategories = [];
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
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Wrap(
            runAlignment: WrapAlignment.center,
            runSpacing: 15.0,
            spacing: 5,
            children: [
              ...widget.categories.map(
                (e) => SizedBox(
                  height: 50,
                  width: 120,
                  child: CategoryItem(
                    category: e.title,
                    isActive:
                        selectedMainCategories.any((cat) => cat.id == e.id),
                    onTap: () {
                      setState(() {
                        if (selectedMainCategories
                            .any((cat) => cat.id == e.id)) {
                          selectedMainCategories
                              .removeWhere((cat) => cat.id == e.id);
                        } else {
                          selectedMainCategories.add(e);
                        }
                      });
                      widget
                          .onSelectedCategoriesChanged(selectedMainCategories);
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

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
      height: 150,
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
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
        ],
      ),
    );
  }
}
