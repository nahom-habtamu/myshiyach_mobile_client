import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_categories.dart';
import 'get_all_categories_state.dart';

class GetAllCategoriesCubit extends Cubit<GetAllCategoriesState> {
  final GetAllCategories getAllCategories;
  GetAllCategoriesCubit(
    this.getAllCategories,
  ) : super(GetAllCategoriesEmpty());

  void call() async {
    try {
      emit(GetAllCategoriesEmpty());
      emit(GetAllCategoriesLoading());
      var categories = await getAllCategories.call();
      if (categories.isNotEmpty) {
        emit(GetAllCategoriesLoaded(categories));
      } else {
        emit(GetAllCategoriesEmpty());
      }
    } catch (e) {
      emit(GetAllCategoriesError(message: e.toString()));
    }
  }
}
