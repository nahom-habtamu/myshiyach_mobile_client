import '../../data/models/register_user/register_user_request_model.dart';

class OtpVerficationPageArgument {
  final RegisterUserRequestModel registerUserRequest;
  final String phoneNumberVerificationId;
  OtpVerficationPageArgument(
    this.registerUserRequest,
    this.phoneNumberVerificationId,
  );
}
