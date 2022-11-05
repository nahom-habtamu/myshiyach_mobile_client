import '../contracts/search_delegate_service.dart';

class AddKeywordToSearchHistory {
  final SearchDelegateService repository;

  AddKeywordToSearchHistory(this.repository);

  Future<void> call(String keyword) {
    return repository.addKeywordToSearchHistory(keyword);
  }
}
