import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network_info.dart';
import '../../../domain/usecases/report_user.dart';
import 'report_user_state.dart';

class ReportUserCubit extends Cubit<ReportUserState> {
  final ReportUser reportUser;
  final NetworkInfo networkInfo;
  ReportUserCubit(this.reportUser, this.networkInfo) : super(ReportUserEmpty());

  void clear() {
    emit(ReportUserEmpty());
  }

  void call(String id, String token) async {
    try {
      if (await networkInfo.isConnected()) {
        emit(ReportUserEmpty());
        emit(ReportUserLoading());
        var product = await reportUser.call(id, token);
        emit(ReportUserSuccessfull(product));
      } else {
        emit(ReportUserNoNetwork());
      }
    } catch (e) {
      emit(ReportUserError(message: e.toString()));
    }
  }
}
