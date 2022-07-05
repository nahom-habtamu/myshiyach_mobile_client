import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/enitites/user.dart';
import '../../../domain/usecases/get_user_by_id.dart';

class GetUserByIdCubit extends Cubit<User?> {
  final GetUserById getCurrentUser;
  GetUserByIdCubit(this.getCurrentUser) : super(null);

  Future<User?> call(String id, String token) async {
    try {
      return await getCurrentUser.call(id, token);
    } catch (e) {
      return null;
    }
  }
}
