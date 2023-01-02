import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/data/models/user/user_model.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/get_user_by_username.dart';
import '../../../domain/usecases/verify_phone_number.dart';
import 'verify_phone_number_state.dart';

class VerifyPhoneNumberCubit extends Cubit<VerifyPhoneNumberState> {
  final VerifyPhoneNumber verifyPhoneNumber;
  final GetUserByUsername getUserByUsername;
  final NetworkInfo networkInfo;
  VerifyPhoneNumberCubit(
    this.verifyPhoneNumber,
    this.networkInfo,
    this.getUserByUsername,
  ) : super(Empty());

  void clear() {
    emit(Empty());
  }

  Future<void> verify(String phoneNumber, bool checkDuplicate) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(Empty());
        emit(Loading());

        if (checkDuplicate) {
          var result = await fetchUserByUsername(phoneNumber);
          if (result == null) {
            goToVerification(phoneNumber);
          } else {
            throw Error(message: "User Already Registered");
          }
        } else {
          goToVerification(phoneNumber);
        }
      } else {
        emit(NoNetwork());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  void goToVerification(String phoneNumber) {
    verifyPhoneNumber.call(
      phoneNumber,
      (FirebaseAuthException e) => emit(Error(message: e.toString())),
      (PhoneAuthCredential credential) => {},
      (verficationID, resendToken) => emit(CodeSent(verficationID)),
    );
  }

  Future<UserModel?> fetchUserByUsername(String phoneNumber) async {
    try {
      return await getUserByUsername.call(phoneNumber);
    } catch (e) {
      return null;
    }
  }
}
