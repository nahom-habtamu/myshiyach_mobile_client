import '../../../domain/enitites/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String text,
    required String senderId,
    required String recieverId,
  }) : super(
          text: text,
          senderId: senderId,
          recieverId: recieverId,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json["text"],
      senderId: json["senderId"],
      recieverId: json["recieverId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "text": text,
        "senderId": senderId,
        "recieverId": recieverId,
      };

  static List<MessageModel> parseMessagesFromJson(dynamic jsonList) {
    var messages = <MessageModel>[];
    if (jsonList.length > 0) {
      jsonList.forEach((e) => {messages.add(MessageModel.fromJson(e))});
    }
    return messages;
  }
}
