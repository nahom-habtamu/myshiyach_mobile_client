import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/conversation/add_conversation_model.dart';
import '../../../domain/enitites/conversation.dart';
import '../../../domain/usecases/create_conversation.dart';
import '../../../domain/usecases/get_conversation_by_members.dart';
import '../../../domain/usecases/get_user_by_id.dart';
import '../../screen_arguments/chat_detail_page_arguments.dart';
import 'handle_going_to_message_state.dart';

class HandleGoingToMessageCubit extends Cubit<HandleGoingToMessageState> {
  final CreateConversation createConversation;
  final GetConversationByMembers getConversationByMembers;
  final GetUserById getUserById;

  HandleGoingToMessageCubit({
    required this.createConversation,
    required this.getConversationByMembers,
    required this.getUserById,
  }) : super(AddConversationEmpty());

  void clearState(){
    emit(AddConversationEmpty());
  }

  void call(
    AddConversationModel addConversationModel,
    String currentUserId,
    String token,
  ) async {
    try {
      emit(AddConversationEmpty());
      emit(AddConversationLoading());

      var conversationFound = getConversationByMembers.call(
        addConversationModel.memberOne,
        addConversationModel.memberTwo,
      );

      var isStreamEmpty = await checkStream(conversationFound);

      if (isStreamEmpty) {
        _handleCreatingConversationCase(
          addConversationModel,
          currentUserId,
          token,
        );
      } else {
        _handleExistingConversationCase(
          conversationFound,
          currentUserId,
          token,
        );
      }
    } catch (e) {
      emit(AddConversationError(message: e.toString()));
    }
  }

  Future<bool> checkStream(Stream<Conversation> conversationFound) async {
    try {
      var isStreamEmpty = await conversationFound.isEmpty;
      return isStreamEmpty;
    } catch (e) {
      return true;
    }
  }

  void _handleExistingConversationCase(
    Stream<Conversation?> conversationFound,
    String currentUserId,
    String token,
  ) async {
    var conversation = await conversationFound.first;
    var strangerUserId = _getStrangerId(conversation!, currentUserId);
    var strangerUser = await getUserById.call(strangerUserId, token);

    ChatDetailPageArguments chatDetailPageArguments = ChatDetailPageArguments(
      conversationId: conversation.id,
      strangerUser: strangerUser,
    );

    emit(AddConversationSuccessfull(chatDetailPageArguments));
  }

  void _handleCreatingConversationCase(
    AddConversationModel addConversationModel,
    String currentUserId,
    String token,
  ) async {

    var createdConversation =
        await createConversation.call(addConversationModel);
    var strangerUserId = _getStrangerId(createdConversation, currentUserId);
    var strangerUser = await getUserById.call(strangerUserId, token);

    ChatDetailPageArguments chatDetailPageArguments = ChatDetailPageArguments(
      conversationId: createdConversation.id,
      strangerUser: strangerUser,
    );

    emit(AddConversationSuccessfull(chatDetailPageArguments));
  }

  String _getStrangerId(Conversation conversation, String currentUserId) {
    var memberOne = conversation.memberOne;
    var memberTwo = conversation.memberTwo;
    var strangerId = currentUserId == memberOne ? memberTwo : memberOne;
    return strangerId;
  }
}
