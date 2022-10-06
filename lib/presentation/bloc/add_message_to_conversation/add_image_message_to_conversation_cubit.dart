import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/conversation/message_model.dart';
import '../../../domain/usecases/add_message_to_conversation.dart';
import '../../../domain/usecases/upload_pictures.dart';
import 'add_image_message_to_conversation_state.dart';

class AddImageMessageToConversationCubit
    extends Cubit<AddImageMessageToConversationState> {
  final AddMessageToConversation addMessageToConversation;
  final UploadPictures uploadPictures;
  AddImageMessageToConversationCubit(
    this.addMessageToConversation,
    this.uploadPictures,
  ) : super(AddImageMessageToConversationNotTriggered());

  void clear() {
    emit(AddImageMessageToConversationNotTriggered());
  }

  void call(
    String conversationId,
    List<MessageModel> messagesToAdd,
    dynamic images,
  ) async {
    try {
      emit(AddImageMessageToConversationLoading());
      var uploadedImage = await uploadPictures.call(
        images,
        "conversation_images",
      );
      for (var i = 0; i < images.length; i++) {
        messagesToAdd[i].content = uploadedImage[i];
        await addMessageToConversation.call(
          conversationId,
          messagesToAdd[i],
        );
      }
      emit(AddImageMessageToConversationSuccessfull());
    } catch (e) {
      emit(AddImageMessageToConversationError(message: e.toString()));
    }
  }
}
