import 'message.dart';

class Conversation {
  final String id;
  final String memberOne;
  final String memberTwo;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.memberOne,
    required this.memberTwo,
    required this.messages,
  });
}
