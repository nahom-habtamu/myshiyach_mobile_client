import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/enitites/conversation.dart';
import '../../../domain/usecases/get_conversation_by_id.dart';

class GetConversationByIdCubit extends Cubit<Stream<Conversation>> {
  final GetConversationById getConvsersationById;

  GetConversationByIdCubit(this.getConvsersationById)
      : super(const Stream.empty());

  void call(String id) {
    var conversations = getConvsersationById.call(id);
    emit(conversations);
  }
}
