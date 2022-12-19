class User {
  final String fullName;
  final String? email;
  final String phoneNumber;
  final String id;
  final bool isReported;

  User({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.id,
    required this.isReported,
  });
}
