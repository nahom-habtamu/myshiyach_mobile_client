import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_user_by_id.dart';
import 'get_user_by_id_state.dart';

class GetUserByIdCubit extends Cubit<GetUserByIdState> {
  final GetUserById getCurrentUser;
  GetUserByIdCubit(this.getCurrentUser) : super(GetUserByIdEmpty());

  void call(String id, String token) async {
    try {
      emit(GetUserByIdEmpty());
      emit(GetUserByIdLoading());
      var user = await getCurrentUser.call(id, token);
      emit(GetUserByIdLoaded(user));
    } catch (e) {
      emit(GetUserByIdError(message: e.toString()));
    }
  }
}
