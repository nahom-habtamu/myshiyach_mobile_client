import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../data/models/register_user/register_user_request_model.dart';
import '../../../domain/usecases/authenticate_phone_number.dart';
import '../../../domain/usecases/register_user.dart';
import 'register_user_state.dart';

class RegisterUserCubit extends Cubit<RegisterUserState> {
  final RegisterUser registerUser;
  final AuthenticatePhoneNumber authenticatePhoneNumber;
  final NetworkInfo networkInfo;
  RegisterUserCubit(
    this.registerUser,
    this.authenticatePhoneNumber,
    this.networkInfo,
  ) : super(RegisterUserEmpty());

  void clear() {
    emit(RegisterUserEmpty());
  }

  void signUpUser(
      RegisterUserRequestModel request, PhoneAuthCredential credential) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(RegisterUserEmpty());
        emit(RegisterUserLoading());
        await authenticatePhoneNumber.call(credential);
        await registerUser.call(request);
        emit(RegisterUserSuccessfull());
      } else {
        emit(RegisterUserNoNetwork());
      }
    } catch (e) {
      emit(RegisterUserError(message: e.toString()));
    }
  }
}
