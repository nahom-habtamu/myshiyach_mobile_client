import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/core/services/network_info.dart';
import 'package:mnale_client/presentation/bloc/get_all_conversations/get_all_conversations_state.dart';

import '../../../domain/usecases/get_all_conversations.dart';

class GetAllConversationsCubit extends Cubit<GetAllConversationsState> {
  final GetAllConversations getAllConversations;
  final NetworkInfo networkInfo;
  GetAllConversationsCubit(this.getAllConversations, this.networkInfo)
      : super(GetAllConversationStateEmpty());

  void call(String currentUserId) async {
    if (await networkInfo.isConnected()) {
      var conversations = getAllConversations.call(currentUserId);
      emit(GetAllConversationStateLoaded(conversations));
    } else {
      emit(GetAllConversationStateNoNetwork());
    }
  }
}
