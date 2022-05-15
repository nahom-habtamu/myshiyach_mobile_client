import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login/login_request_model.dart';
import '../../../domain/usecases/login.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login login;
  AuthCubit(this.login) : super(Empty());

  void loginUser(LoginRequestModel request) async {
    try {
      emit(Empty());
      emit(Loading());
      var authResult = await login.call(request);
      emit(Loaded(authResult));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
