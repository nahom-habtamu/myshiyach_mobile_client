import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/register_user/register_user_request_model.dart';
import '../../../domain/usecases/register_user.dart';
import 'register_user_state.dart';

class RegisterUserCubit extends Cubit<RegisterUserState> {
  final RegisterUser registerUser;
  RegisterUserCubit(this.registerUser) : super(Empty());

  void signInUser(RegisterUserRequestModel request) async {
    try {
      emit(Empty());
      emit(Loading());
      await registerUser.call(request);
      emit(Loaded());
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
