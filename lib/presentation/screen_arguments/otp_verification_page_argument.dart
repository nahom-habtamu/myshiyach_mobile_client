class OtpVerficationPageArgument {
  final String phoneNumber;
  final String phoneNumberVerificationId;
  final Function(String pin, String verificationId) renderActionButton;
  final Function renderErrorWidget;
  OtpVerficationPageArgument({
    required this.phoneNumberVerificationId,
    required this.phoneNumber,
    required this.renderActionButton,
    required this.renderErrorWidget,
  });
}
