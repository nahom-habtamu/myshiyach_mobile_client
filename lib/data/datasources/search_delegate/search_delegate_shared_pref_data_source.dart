import 'package:shared_preferences/shared_preferences.dart';

import 'search_delegate_data_source.dart';

class SearchDelegateSharedPrefDataSource extends SearchDelegateDataSource {
  final SharedPreferences sharedPreferences;

  SearchDelegateSharedPrefDataSource(this.sharedPreferences);

  @override
  Future<List<String>> getRecentSearches(String query) async {
    final allSearches = sharedPreferences.getStringList("recentSearches") ?? [];
    return query.isNotEmpty
        ? allSearches
        : allSearches.where((search) => search.startsWith(query)).toList();
  }

  @override
  Future<void> addKeywordToSeachHistory(String keyword) async {
    Set<String> allSearches =
        sharedPreferences.getStringList("recentSearches")?.toSet() ?? {};
    allSearches = {keyword, ...allSearches};
    sharedPreferences.setStringList("recentSearches", allSearches.toList());
  }
}
