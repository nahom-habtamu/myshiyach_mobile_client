import '../../../domain/enitites/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String text,
    required String senderId,
    required String recieverId,
    required String createdDateTime,
    required bool isSeen,
  }) : super(
          text: text,
          senderId: senderId,
          recieverId: recieverId,
          createdDateTime: createdDateTime,
          isSeen: isSeen,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json["text"],
      senderId: json["senderId"],
      recieverId: json["recieverId"],
      createdDateTime: json["createdDateTime"],
      isSeen: json["isSeen"],
    );
  }

  factory MessageModel.fromMessage(Message message) {
    return MessageModel(
      text: message.text,
      senderId: message.senderId,
      recieverId: message.recieverId,
      createdDateTime: message.createdDateTime,
      isSeen: message.isSeen,
    );
  }

  Map<String, dynamic> toJson() => {
        "text": text,
        "senderId": senderId,
        "recieverId": recieverId,
        "createdDateTime": createdDateTime,
        "isSeen": isSeen,
      };

  static List<MessageModel> parseMessagesFromJson(dynamic jsonList) {
    var messages = <MessageModel>[];
    if (jsonList.length > 0) {
      jsonList.forEach((e) => {messages.add(MessageModel.fromJson(e))});
    }
    return messages;
  }
}
