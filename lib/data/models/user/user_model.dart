import '../../../domain/enitites/user.dart';

class UserModel extends User {
  UserModel({
    required String fullName,
    required String? email,
    required String phoneNumber,
    required String id,
  }) : super(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          id: id,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json["fullName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      id: json["_id"],
    );
  }
}
