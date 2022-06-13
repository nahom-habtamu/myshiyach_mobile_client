import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/change_password.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePassword changePassword;
  ChangePasswordCubit(this.changePassword) : super(ChangePasswordEmpty());

  void clear() {
    emit(ChangePasswordEmpty());
  }

  void call(String phoneNumber, String password) async {
    try {
      emit(ChangePasswordEmpty());
      emit(ChangePasswordLoading());
      await changePassword.call(phoneNumber, password);
      emit(ChangePasswordSuccessfull());
    } catch (e) {
      emit(ChangePasswordError(message: e.toString()));
    }
  }
}
