import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/filter/filter_criteria_model.dart';
import '../../../domain/enitites/main_category.dart';
import '../../../domain/enitites/product.dart';
import '../../bloc/add_keyword_to_search_history/add_keyword_to_search_history_cubit.dart';
import '../../bloc/get_recent_searches/get_recent_searches_cubit.dart';
import '../../pages/filter_data_page.dart';
import '../../screen_arguments/filter_page_argument.dart';
import '../../utils/custom_search_history_delegate.dart';

class SearchBar extends StatefulWidget {
  final Function onSearchFilterApplied;
  final List<MainCategory> categories;
  final List<Product> products;
  final Function onSearchSubmitted;
  final FilterCriteriaModel? initialFilterCriteria;

  const SearchBar({
    Key? key,
    required this.categories,
    required this.onSearchFilterApplied,
    required this.products,
    required this.onSearchSubmitted,
    required this.initialFilterCriteria,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FilterCriteriaModel? filterResult;
  String keyword = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showSearch() async {
    final searchText = await showSearch<String>(
      context: context,
      delegate: CustomSearchHistoryDelegate(
        onSearchChanged: _getRecentSearchesLike,
      ),
    );
    if (searchText != null) {
      setState(() {
        keyword = searchText;
      });
      widget.onSearchSubmitted(searchText);
      context.read<AddKeywordToSearchHistoryCubit>().execute(keyword);
    }
  }

  Future<List<String>> _getRecentSearchesLike(_) async {
    return context.read<GetRecentSearchesCubit>().execute(keyword);
  }

  @override
  Widget build(BuildContext context) {
    filterResult = widget.initialFilterCriteria;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              height: 35,
              child: TextFormField(
                key: Key(keyword),
                initialValue: keyword,
                readOnly: true,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  if (value.isEmpty) widget.onSearchSubmitted("");
                },
                onTap: () => _showSearch(),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).homeSearchBarHint,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black26,
                      width: 1,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black26,
                      width: 1,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black26,
                      width: 1,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        keyword = "";
                      });
                      widget.onSearchSubmitted(keyword);
                    },
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  filled: true,
                  fillColor: Colors.white,
                ),
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
