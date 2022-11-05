import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_keyword_to_search_history.dart';
import 'add_keyword_to_search_history_state.dart';

class AddKeywordToSearchHistoryCubit
    extends Cubit<AddKeywordToSearchHistoryState> {
  final AddKeywordToSearchHistory addKeywordToSearchHistory;
  AddKeywordToSearchHistoryCubit(this.addKeywordToSearchHistory)
      : super(NotFired());

  Future<void> execute(String keyword) async {
    try {
      emit(Loading());
      await addKeywordToSearchHistory.call(keyword);
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
