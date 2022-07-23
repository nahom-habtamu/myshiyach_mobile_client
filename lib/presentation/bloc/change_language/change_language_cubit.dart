import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/change_password.dart';

class ChangeLanguageCubit extends Cubit<String> {
  final ChangePassword changePassword;
  ChangeLanguageCubit(this.changePassword) : super("en");

  void call(String language) {
    emit(language);
  }
}
