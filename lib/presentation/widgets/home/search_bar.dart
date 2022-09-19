import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    filterResult = widget.initialFilterCriteria;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
              onChanged: (value) => {
                widget.onSearchQueryChanged(value),
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).homeSearchBarHint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 25,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                  ),
                  onPressed: () {
                    _controller.text = "";
                    widget.onSearchQueryChanged("");
                  },
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                renderGoToFiltersButton(),
                renderActiveFilterIndicatingLabel()
              ],
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
      icon: const Icon(Icons.filter_list),
    );
  }

  Visibility renderActiveFilterIndicatingLabel() {
    return Visibility(
      visible: filterIsNotEmpty(),
      child: const Positioned(
        left: 2,
        top: 5,
        child: CircleAvatar(
          backgroundColor: Color(0xFFFAF6F6),
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
    return (!(filterResult == null || filterResult!.areAllValuesNull()));
  }
}
