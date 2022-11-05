import '../contracts/search_delegate_service.dart';

class GetRecentSearches {
  final SearchDelegateService repository;

  GetRecentSearches(this.repository);

  Future<List<String>> call(String query) {
    return repository.getRecentSearches(query);
  }
}
