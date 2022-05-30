import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login/login_request_model.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/login.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login login;
  final GetCurrentUser getCurrentUser;
  AuthCubit(this.login, this.getCurrentUser) : super(AuthNotTriggered());

  void loginUser(LoginRequestModel request) async {
    try {
      emit(AuthNotTriggered());
      emit(AuthLoading());
      var authResult = await login.call(request);
      var currentUser = await getCurrentUser.call(authResult.token);
      emit(AuthSuccessfull(authResult, currentUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
