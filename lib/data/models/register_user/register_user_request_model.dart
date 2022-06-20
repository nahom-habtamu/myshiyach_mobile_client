class RegisterUserRequestModel {
  final String fullName;
  final String password;
  final String phoneNumber;

  const RegisterUserRequestModel({
    required this.fullName,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName.trim(),
        "password": password.trim(),
        "phoneNumber": phoneNumber.trim(),
        "email": "",
      };
}
