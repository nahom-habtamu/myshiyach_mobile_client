class Message {
  final String text;
  final String senderId;
  final String recieverId;
  final String createdDateTime;
  final bool isSeen;

  Message({
    required this.text,
    required this.senderId,
    required this.recieverId,
    required this.createdDateTime,
    required this.isSeen,
  });
}
