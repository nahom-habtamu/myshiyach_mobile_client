import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/authenticate_phone_number.dart';
import 'authenticate_phone_number_state.dart';

class AuthPhoneNumberCubit extends Cubit<AuthPhoneNumberState> {
  final AuthenticatePhoneNumber authenticatePhoneNumber;
  AuthPhoneNumberCubit(this.authenticatePhoneNumber)
      : super(AuthPhoneNumberEmpty());

  Future<void> call(PhoneAuthCredential credential) async {
    try {
      emit(AuthPhoneNumberEmpty());
      emit(AuthPhoneNumberLoading());
      authenticatePhoneNumber.call(credential);
    } catch (e) {
      emit(AuthPhoneNumberError(message: e.toString()));
    }
  }
}
