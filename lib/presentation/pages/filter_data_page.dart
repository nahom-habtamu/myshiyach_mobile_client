import 'package:flutter/material.dart';

import '../../domain/enitites/main_category.dart';
import '../screen_arguments/filter_page_argument.dart';
import '../widgets/common/curved_button.dart';
import '../widgets/filter/filter_by_price.dart';
import '../widgets/filter/filter_categories.dart';

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
