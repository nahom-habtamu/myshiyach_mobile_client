import '../../../domain/enitites/message.dart';

class MessageModel extends Message {
  MessageModel(
      {required String content,
      required String senderId,
      required String recieverId,
      required String createdDateTime,
      required bool isSeen,
      required String type})
      : super(
          content: content,
          senderId: senderId,
          recieverId: recieverId,
          createdDateTime: createdDateTime,
          isSeen: isSeen,
          type: type,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        content: json["content"],
        senderId: json["senderId"],
        recieverId: json["recieverId"],
        createdDateTime: json["createdDateTime"],
        isSeen: json["isSeen"],
        type: json["type"]);
  }

  factory MessageModel.fromMessage(Message message) {
    return MessageModel(
        content: message.content,
        senderId: message.senderId,
        recieverId: message.recieverId,
        createdDateTime: message.createdDateTime,
        isSeen: message.isSeen,
        type: message.type);
  }

  Map<String, dynamic> toJson() => {
        "content": content,
        "senderId": senderId,
        "recieverId": recieverId,
        "createdDateTime": createdDateTime,
        "isSeen": isSeen,
        "type": type,
      };

  static List<MessageModel> parseMessagesFromJson(dynamic jsonList) {
    var messages = <MessageModel>[];
    if (jsonList.length > 0) {
      jsonList.forEach((e) => {messages.add(MessageModel.fromJson(e))});
    }
    return messages;
  }
}
