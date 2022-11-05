import '../../domain/contracts/search_delegate_service.dart';
import '../datasources/search_delegate/search_delegate_data_source.dart';

class SearchDelegateRepository extends SearchDelegateService {
  final SearchDelegateDataSource searchDelegateDataSource;

  SearchDelegateRepository(this.searchDelegateDataSource);
  @override
  Future<List<String>> getRecentSearches(String query) {
    return searchDelegateDataSource.getRecentSearches(query);
  }

  @override
  Future<void> addKeywordToSearchHistory(String keyword) {
    return searchDelegateDataSource.addKeywordToSeachHistory(keyword);
  }
}
