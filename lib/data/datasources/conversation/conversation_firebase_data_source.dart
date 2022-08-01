import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/conversation/add_conversation_model.dart';
import '../../models/conversation/conversation_model.dart';
import '../../models/conversation/message_model.dart';
import 'conversation_data_source.dart';

class ConversationFirebaseDataSource extends ConversationDataSource {
  CollectionReference? conversations;
  ConversationFirebaseDataSource(FirebaseFirestore instance) {
    conversations = instance.collection("conversations");
  }

  @override
  Stream<List<ConversationModel>> getAllConversations(String currentUserId) {
    return conversations!.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ConversationModel.fromDocumentSnapshot(doc))
        .where((con) =>
            (con.memberOne == currentUserId ||
                con.memberTwo == currentUserId) &&
            con.messages.isNotEmpty)
        .toList());
  }

  @override
  void addMessageToConversation(
      String conversationId, MessageModel messageToAdd) {
    conversations!.doc(conversationId).update({
      "messages": FieldValue.arrayUnion([messageToAdd.toJson()])
    });
  }

  @override
  Stream<ConversationModel> getConversationById(String id) {
    return conversations!.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ConversationModel.fromDocumentSnapshot(doc))
        .firstWhere((element) => element.id == id));
  }

  @override
  Stream<ConversationModel> getConversationByMembers(
    String memberOneId,
    String memberTwoId,
  ) {
    try {
      return conversations!.snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => ConversationModel.fromDocumentSnapshot(doc))
                .singleWhere(
                  (element) => _compareConversationWithMembers(
                    element,
                    memberOneId,
                    memberTwoId,
                  ),
                ),
          );
    } catch (e) {
      return const Stream.empty();
    }
  }

  bool _compareConversationWithMembers(
    ConversationModel element,
    String memberOneId,
    String memberTwoId,
  ) {
    return (element.memberOne == memberOneId &&
            element.memberTwo == memberTwoId) ||
        (element.memberOne == memberTwoId && element.memberTwo == memberOneId);
  }

  @override
  Future<ConversationModel> createConversation(
    AddConversationModel addConversationModel,
  ) async {
    var result = await conversations!.add({
      "memberOne": addConversationModel.memberOne,
      "memberTwo": addConversationModel.memberTwo,
      "messages": [],
    });

    return conversations!
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ConversationModel.fromDocumentSnapshot(doc))
              .firstWhere(
                (element) => element.id == result.id,
              ),
        )
        .first;
  }

  @override
  void markAllMessagesAsRead(
      String currentUserId, String conversationId) async {
    var conversation = await conversations!
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConversationModel.fromDocumentSnapshot(doc))
            .firstWhere((element) => element.id == conversationId))
        .first;

    if (_hasUnreadMessages(conversation, currentUserId)) {
      var readMessages = conversation.messages.map(
        (e) {
          if (e.senderId != currentUserId && e.isSeen) {
            return MessageModel.fromMessage(e).toJson();
          } else {
            return MessageModel(
              text: e.text,
              senderId: e.senderId,
              recieverId: e.recieverId,
              createdDateTime: e.createdDateTime,
              isSeen: true,
            ).toJson();
          }
        },
      ).toList();

      conversations!.doc(conversationId).update({
        "messages": [...readMessages]
      });
    }
  }

  bool _hasUnreadMessages(
          ConversationModel conversation, String currentUserId) =>
      conversation.messages
          .where((e) => e.recieverId == currentUserId || !e.isSeen)
          .isNotEmpty;
}
