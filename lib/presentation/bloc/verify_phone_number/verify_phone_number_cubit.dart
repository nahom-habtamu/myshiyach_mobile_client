import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/verify_phone_number.dart';
import 'verify_phone_number_state.dart';

class VerifyPhoneNumberCubit extends Cubit<VerifyPhoneNumberState> {
  final VerifyPhoneNumber verifyPhoneNumber;
  VerifyPhoneNumberCubit(this.verifyPhoneNumber) : super(Empty());

  Future<void> verify(String phoneNumber) async {
    try {
      emit(Empty());
      emit(Loading());
      verifyPhoneNumber.call(
        phoneNumber,
        (FirebaseAuthException e) => emit(Error(message: e.toString())),
        (PhoneAuthCredential credential) => {},
        (verficationID, resendToken) => emit(CodeSent(verficationID)),
      );
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
