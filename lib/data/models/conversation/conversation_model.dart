import '../../../domain/enitites/conversation.dart';
import 'message_model.dart';

class ConversationModel extends Conversation {
  ConversationModel({
    required String id,
    required String memberOne,
    required String memberTwo,
    required List<MessageModel> messages,
  }) : super(
          id: id,
          memberOne: memberOne,
          memberTwo: memberTwo,
          messages: messages,
        );

  factory ConversationModel.fromDocumentSnapshot(dynamic doc) {
    return ConversationModel(
      id: doc.id,
      memberOne: doc.data()!["memberOne"],
      memberTwo: doc.data()!["memberTwo"],
      messages: MessageModel.parseMessagesFromJson(doc.data()!["messages"]),
    );
  }

  static List<ConversationModel> parseSnapshotConversationsToList(
      dynamic snapshots) {
    var conversations = <ConversationModel>[];
    if (snapshots.length > 0) {
      snapshots.forEach(
        (e) => {
          conversations.add(
            ConversationModel.fromDocumentSnapshot(e),
          ),
        },
      );
    }
    return conversations;
  }
}
