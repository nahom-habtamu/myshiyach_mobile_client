import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/mark_messages_as_read.dart';

class MarkMessagesAsReadCubit extends Cubit<void> {
  final MarkMessagesAsRead markMessagesAsRead;
  MarkMessagesAsReadCubit(
    this.markMessagesAsRead,
  ) : super(const Stream.empty());

  void call(
    String currentUserId,
    String conversationId
  ) {
    markMessagesAsRead.call(currentUserId, conversationId);
  }
}
