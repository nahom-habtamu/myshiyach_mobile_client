import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/core/services/network_info.dart';
import 'package:mnale_client/data/models/login/login_result_model.dart';

import '../../../data/models/login/login_request_model.dart';
import '../../../domain/enitites/user.dart';
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
  final NetworkInfo networkInfo;
  AuthCubit({
    required this.login,
    required this.getCurrentUser,
    required this.extractToken,
    required this.storeUserCredentials,
    required this.getStoredUserCredentials,
    required this.networkInfo,
  }) : super(AuthNotTriggered());

  void clear() {
    emit(AuthNotTriggered());
  }

  void updateFavoriteProducts(
      String token, User oldUser, List<String> favoriteProducts) async {
    emit(
      AuthSuccessfull(
        LoginResultModel(token: token),
        User(
          fullName: oldUser.fullName,
          email: oldUser.email,
          phoneNumber: oldUser.phoneNumber,
          id: oldUser.id,
          isReported: oldUser.isReported,
          favoriteProducts: favoriteProducts,
        ),
      ),
    );
  }

  void loginUser(LoginRequestModel? request) async {
    try {
      if (await networkInfo.isConnected()) {
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
      } else {
        emit(AuthNoNetwork());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
