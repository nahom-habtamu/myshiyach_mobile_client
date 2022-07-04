import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login/login_request_model.dart';
import '../../../domain/usecases/extract_token.dart';
import '../../../domain/usecases/get_stored_user_credentials.dart';
import '../../../domain/usecases/get_user_by_id.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/store_user_credentails.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login login;
  final GetUserById getCurrentUser;
  final ExtractToken extractToken;
  final StoreUserCredentials storeUserCredentials;
  final GetStoredUserCredentials getStoredUserCredentials;
  AuthCubit({
    required this.login,
    required this.getCurrentUser,
    required this.extractToken,
    required this.storeUserCredentials,
    required this.getStoredUserCredentials,
  }) : super(AuthNotTriggered());

  void clear() {
    emit(AuthNotTriggered());
  }

  void loginUser(LoginRequestModel? request) async {
    try {
      emit(AuthNotTriggered());
      emit(AuthLoading());

      request ??= await getStoredUserCredentials.call();

      if (request!.userName.isEmpty || request.password.isEmpty) {
        throw Exception("Invalid Credentials");
      }

      var authResult = await login.call(request);
      var decodedToken = extractToken.call(authResult.token);
      var currentUser = await getCurrentUser.call(
        decodedToken["sub"],
        authResult.token,
      );

      storeUserCredentials.call(request);

      emit(AuthSuccessfull(authResult, currentUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
