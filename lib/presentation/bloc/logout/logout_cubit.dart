import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login/login_request_model.dart';
import '../../../domain/usecases/store_user_credentails.dart';
import 'logout_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  final StoreUserCredentials storeUserCredentials;
  LogOutCubit({
    required this.storeUserCredentials,
  }) : super(LogOutNotTriggered());

  void clear() {
    emit(LogOutNotTriggered());
  }

  void call() async {
    try {
      emit(LogOutNotTriggered());
      emit(LogOutLoading());

      var request = const LoginRequestModel(
        userName: "",
        password: "",
      );

      storeUserCredentials.call(request);
      emit(LogOutSuccessfull());
    } catch (e) {
      emit(LogOutError(message: e.toString()));
    }
  }
}
