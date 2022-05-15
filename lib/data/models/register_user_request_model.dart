class RegisterUserRequestModel {
  final String fullName;
  final String password;
  final String phoneNumber;

  const RegisterUserRequestModel({
    required this.fullName, 
    required this.password, 
    required this.phoneNumber,
  });

  Map<String,dynamic> toJson() => {
    "fullName": fullName,
    "password": password,
    "phoneNumber": phoneNumber,
    "email" : "someemail@gmail.com",
    "profilePicture" : "thisthingisdropped"
  };
}