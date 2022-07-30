import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/core/services/network_info.dart';

import '../../../domain/usecases/verify_phone_number.dart';
import 'verify_phone_number_state.dart';

class VerifyPhoneNumberCubit extends Cubit<VerifyPhoneNumberState> {
  final VerifyPhoneNumber verifyPhoneNumber;
  final NetworkInfo networkInfo;
  VerifyPhoneNumberCubit(this.verifyPhoneNumber, this.networkInfo)
      : super(Empty());

  void clear() {
    emit(Empty());
  }

  Future<void> verify(String phoneNumber) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());
        verifyPhoneNumber.call(
          phoneNumber,
          (FirebaseAuthException e) => emit(Error(message: e.toString())),
          (PhoneAuthCredential credential) => {},
          (verficationID, resendToken) => emit(CodeSent(verficationID)),
        );
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
