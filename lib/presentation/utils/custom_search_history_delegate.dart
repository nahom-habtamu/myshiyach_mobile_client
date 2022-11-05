import 'package:flutter/material.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class CustomSearchHistoryDelegate extends SearchDelegate<String> {
  final OnSearchChanged? onSearchChanged;
  List<String> _oldFilters = const [];

  CustomSearchHistoryDelegate({String? searchFieldLabel, this.onSearchChanged})
      : super(searchFieldLabel: searchFieldLabel);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  void showResults(BuildContext context) {
    close(context, query);
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: onSearchChanged != null ? onSearchChanged!(query) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data ?? [];
        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.restore),
              title: Text(_oldFilters[index]),
              onTap: () => close(context, _oldFilters[index]),
            );
          },
        );
      },
    );
  }
}
