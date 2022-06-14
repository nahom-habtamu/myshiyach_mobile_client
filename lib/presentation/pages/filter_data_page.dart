import 'package:flutter/material.dart';

import '../../domain/enitites/main_category.dart';
import '../widgets/common/curved_button.dart';
import '../widgets/filter/price_range_slider.dart';
import '../widgets/home/category_item.dart';

class FilterDataPage extends StatelessWidget {
  static String routeName = '/filterDataPage';
  const FilterDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categories =
        ModalRoute.of(context)!.settings.arguments as List<MainCategory>;

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
            const FilterByPrice(),
            const SizedBox(
              height: 25,
            ),
            FilterCategories(
              categories: [...categories],
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: CurvedButton(
                  onPressed: () {},
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
  const FilterCategories({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
}

class _FilterCategoriesState extends State<FilterCategories> {
  List<String> selectedMainCategories = [];
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
                    isActive: selectedMainCategories.contains(e.id),
                    onTap: () {
                      setState(() {
                        if (selectedMainCategories.contains(e.id)) {
                          selectedMainCategories.remove(e.id);
                        } else {
                          selectedMainCategories.add(e.id);
                        }
                      });
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
  const FilterByPrice({
    Key? key,
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
              children: const [
                Text(
                  '\$25',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '\$100',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          PriceRangeSlider(
            minValue: 25,
            maxValue: 150,
            onChanged: (value) {
              setState(() {
                _currentRangeValues = value;
              });
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min Price = ${_currentRangeValues.start.toInt()}\$',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Max Price = ${_currentRangeValues.end.toInt()}\$',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
