class Message {
  String content;
  final String senderId;
  final String recieverId;
  final String createdDateTime;
  final String type;
  final bool isSeen;

  Message({
    required this.content,
    required this.senderId,
    required this.recieverId,
    required this.createdDateTime,
    required this.isSeen,
    required this.type,
  });
}
