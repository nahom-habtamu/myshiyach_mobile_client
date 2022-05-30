import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/enitites/conversation.dart';
import '../../../domain/usecases/get_all_conversations.dart';

class GetAllConversationsCubit extends Cubit<Stream<List<Conversation>>> {
  final GetAllConversations getAllConversations;

  GetAllConversationsCubit(this.getAllConversations)
      : super(const Stream.empty());

  void call() {
    var conversations = getAllConversations.call();
    emit(conversations);
  }
}
