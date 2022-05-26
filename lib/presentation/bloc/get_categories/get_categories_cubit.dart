import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_categories.dart';
import 'get_categories_state.dart';

class GetAllCategoriesCubit extends Cubit<GetAllCategoriesState> {
  final GetAllCategories getAllCategories;
  GetAllCategoriesCubit(this.getAllCategories) : super(Empty());

  void call() async {
    try {
      emit(Empty());
      emit(Loading());
      var categories = await getAllCategories.call();
      if (categories.isNotEmpty) {
        emit(Loaded(categories));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
