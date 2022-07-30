import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/get_all_cities.dart';
import '../../../domain/usecases/get_categories.dart';
import 'get_data_needed_to_manage_post_state.dart';

class GetDataNeededToManagePostCubit
    extends Cubit<GetDataNeededToManagePostState> {
  final GetAllCategories getAllCategories;
  final GetAllCities getAllCities;
  final NetworkInfo networkInfo;
  GetDataNeededToManagePostCubit({
    required this.getAllCategories,
    required this.getAllCities,
    required this.networkInfo,
  }) : super(Empty());

  void call() async {
    try {

      if(await networkInfo.isConnected())
      {
        emit(Empty());
        emit(Loading());
        var categories = await getAllCategories.call();
        var cities = await getAllCities.call();
        if (categories.isNotEmpty && cities.isNotEmpty) {
          emit(Loaded(categories, cities));
        } else {
          emit(Empty());
        }
      }
      else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
