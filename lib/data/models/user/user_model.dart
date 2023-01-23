import '../../../domain/enitites/user.dart';

class UserModel extends User {
  UserModel({
    required String fullName,
    required String? email,
    required String phoneNumber,
    required String id,
    required bool isReported,
    required List<String> favoriteProducts,
  }) : super(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          id: id,
          isReported: isReported,
          favoriteProducts: favoriteProducts,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json["fullName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      id: json["_id"],
      isReported: json["isReported"],
      favoriteProducts: List<String>.from(json["favoriteProducts"]),
    );
  }
}
