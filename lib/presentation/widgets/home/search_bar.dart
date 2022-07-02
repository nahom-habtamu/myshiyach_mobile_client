import 'package:flutter/material.dart';

import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../domain/enitites/main_category.dart';
import '../../../domain/enitites/product.dart';
import '../../pages/filter_data_page.dart';
import '../../screen_arguments/filter_page_argument.dart';

class SearchBar extends StatefulWidget {
  final Function onSearchFilterApplied;
  final List<MainCategory> categories;
  final List<Product> products;
  final Function onSearchQueryChanged;
  final FilterCriteriaModel? initialFilterCriteria;

  const SearchBar({
    Key? key,
    required this.categories,
    required this.onSearchFilterApplied,
    required this.products,
    required this.onSearchQueryChanged,
    required this.initialFilterCriteria,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FilterCriteriaModel? filterResult;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              onChanged: (value) => {
                widget.onSearchQueryChanged(value),
              },
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
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Stack(
                children: [
                  renderGoToFiltersButton(),
                  renderActiveFilterIndicatingLabel()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  IconButton renderGoToFiltersButton() {
    return IconButton(
      onPressed: () async {
        FilterPageArgument filterArgument = buildFilterPageArgument();
        var result = await Navigator.of(context).pushNamed(
          FilterDataPage.routeName,
          arguments: filterArgument,
        );
        setState(() {
          filterResult = result != null ? result as FilterCriteriaModel : null;
        });
        widget.onSearchFilterApplied(result);
      },
      icon: const Icon(Icons.filter),
    );
  }

  Visibility renderActiveFilterIndicatingLabel() {
    return Visibility(
      visible: filterIsNotEmpty(),
      child: const Positioned(
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
      ),
    );
  }

  FilterPageArgument buildFilterPageArgument() {
    var cities = widget.products.map((e) => e.city).toSet().toList();
    var filterArgument = FilterPageArgument(
      allCategories: widget.categories,
      initialFilterCriteria: widget.initialFilterCriteria,
      cities: cities,
    );
    return filterArgument;
  }

  bool filterIsNotEmpty() {
    return filterResult != null;
  }
}
