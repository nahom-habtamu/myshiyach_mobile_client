import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_recent_searches.dart';

class GetRecentSearchesCubit extends Cubit<List<String>> {
  final GetRecentSearches addKeywordToSearchHistory;
  GetRecentSearchesCubit(this.addKeywordToSearchHistory) : super([]);

  Future<List<String>> execute(String keyword) async {
    try {
      return await addKeywordToSearchHistory.call(keyword);
    } catch (e) {
      return [];
    }
  }
}
