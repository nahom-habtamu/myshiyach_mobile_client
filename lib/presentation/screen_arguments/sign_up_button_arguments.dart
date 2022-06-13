import '../../data/models/register_user/register_user_request_model.dart';

class SignUpButtonArguments {
  final RegisterUserRequestModel registerUserRequest;
  final String pin;
  final String verificationId;

  SignUpButtonArguments({
    required this.registerUserRequest,
    required this.pin,
    required this.verificationId,
  });
}
