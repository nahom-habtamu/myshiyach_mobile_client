import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/conversation/conversation_model.dart';
import '../../models/conversation/message_model.dart';
import 'conversation_data_source.dart';

class ConversationFirebaseDataSource extends ConversationDataSource {
  CollectionReference? conversations;
  ConversationFirebaseDataSource(FirebaseFirestore instance) {
    conversations = instance.collection("conversations");
  }

  @override
  Stream<List<ConversationModel>> getAllConversations() {
    return conversations!.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ConversationModel.fromDocumentSnapshot(doc))
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
}
