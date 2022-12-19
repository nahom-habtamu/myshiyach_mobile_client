import '../../../domain/enitites/user.dart';

class UserModel extends User {
  UserModel({
    required String fullName,
    required String? email,
    required String phoneNumber,
    required String id,
    required bool isReported,
  }) : super(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          id: id,
          isReported: isReported,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json["fullName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      id: json["_id"],
      isReported: json["isReported"],
    );
  }
}
