abstract class AddKeywordToSearchHistoryState {}

class NotFired extends AddKeywordToSearchHistoryState {}

class Loading extends AddKeywordToSearchHistoryState {}

class Error extends AddKeywordToSearchHistoryState {
  final String message;
  Error({required this.message});
}
