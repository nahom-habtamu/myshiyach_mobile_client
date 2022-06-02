import '../../domain/enitites/conversation.dart';
import '../../domain/enitites/user.dart';

class ChatDetailPageArguments {
  final Conversation conversation;
  final User strangerUser;

  ChatDetailPageArguments({
    required this.conversation,
    required this.strangerUser,
  });
}
