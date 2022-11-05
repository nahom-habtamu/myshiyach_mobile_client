abstract class SearchDelegateService {
  Future<List<String>> getRecentSearches(String query);
  Future<void> addKeywordToSearchHistory(String keyword);
}
