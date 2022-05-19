import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/register_user/register_user_request_model.dart';
import '../../../domain/usecases/authenticate_phone_number.dart';
import '../../../domain/usecases/register_user.dart';
import 'register_user_state.dart';

class RegisterUserCubit extends Cubit<RegisterUserState> {
  final RegisterUser registerUser;
  final AuthenticatePhoneNumber authenticatePhoneNumber;
  RegisterUserCubit(this.registerUser, this.authenticatePhoneNumber)
      : super(Empty());

  void signUpUser(
      RegisterUserRequestModel request, PhoneAuthCredential credential) async {
    try {
      emit(Empty());
      emit(Loading());
      await authenticatePhoneNumber.call(credential);
      await registerUser.call(request);
      emit(Successfull());
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
