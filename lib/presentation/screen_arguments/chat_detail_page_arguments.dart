import '../../domain/enitites/user.dart';

class ChatDetailPageArguments {
  final String conversationId;
  final User strangerUser;

  ChatDetailPageArguments({
    required this.conversationId,
    required this.strangerUser,
  });
}
