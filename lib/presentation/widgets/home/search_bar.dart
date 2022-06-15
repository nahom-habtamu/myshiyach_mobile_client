import 'dart:math';

import 'package:flutter/material.dart';

import '../../../domain/enitites/main_category.dart';
import '../../../domain/enitites/product.dart';
import '../../pages/filter_data_page.dart';
import '../../screen_arguments/filter_page_argument.dart';

class SearchBar extends StatefulWidget {
  final Function onSearchFilterApplied;
  final List<MainCategory> categories;
  final List<Product> products;
  final Function onSearchQueryChanged;
  const SearchBar({
    Key? key,
    required this.categories,
    required this.onSearchFilterApplied,
    required this.products,
    required this.onSearchQueryChanged,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FilterPageArgument? filterResult;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.73,
            child: TextFormField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              onChanged: (value) => {widget.onSearchQueryChanged(value)},
              decoration: const InputDecoration(
                labelText: "Search Item",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 30,
                ),
                isDense: true,
                contentPadding: EdgeInsets.all(15),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () async {
                    var maxValue =
                        widget.products.map((e) => e.price).reduce(max);
                    var minValue =
                        widget.products.map((e) => e.price).reduce(min);

                    var result = await Navigator.of(context).pushNamed(
                      FilterDataPage.routeName,
                      arguments: FilterPageArgument(
                        categories: widget.categories,
                        minValue: minValue,
                        maxValue: maxValue,
                      ),
                    );
                    setState(() {
                      filterResult = result as FilterPageArgument;
                    });
                    widget.onSearchFilterApplied(result);
                  },
                  icon: const Icon(Icons.filter),
                ),
                filterIsNotEmpty()
                    ? const Positioned(
                        left: 2,
                        top: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 8,
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 0,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool filterIsNotEmpty() {
    return filterResult != null &&
        (filterResult!.categories.isNotEmpty ||
            (filterResult!.maxValue != 0 && filterResult!.minValue != 0));
  }
}
