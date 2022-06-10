import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_all_cities.dart';
import '../../../domain/usecases/get_categories.dart';
import 'get_data_needed_to_manage_post_state.dart';

class GetDataNeededToManagePostCubit
    extends Cubit<GetDataNeededToManagePostState> {
  final GetAllCategories getAllCategories;
  final GetAllCities getAllCities;
  GetDataNeededToManagePostCubit({
    required this.getAllCategories,
    required this.getAllCities,
  }) : super(Empty());

  void call() async {
    try {
      emit(Empty());
      emit(Loading());
      var categories = await getAllCategories.call();
      var cities = await getAllCities.call();
      if (categories.isNotEmpty && cities.isNotEmpty) {
        emit(Loaded(categories, cities));
      } else {
        emit(Empty());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}