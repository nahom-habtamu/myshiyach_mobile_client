abstract class SearchDelegateDataSource {
  Future<List<String>> getRecentSearches(String query);
  Future<void> addKeywordToSeachHistory(String keyword);
}
