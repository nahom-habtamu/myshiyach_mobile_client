import 'package:shared_preferences/shared_preferences.dart';

import '../../models/login/login_request_model.dart';

class UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSource(this.sharedPreferences);

  Future<LoginRequestModel?> getStoredUserCredential() async {
    final String? userName = sharedPreferences.getString("USERNAME");
    final String? password = sharedPreferences.getString("PASSWORD");
    if (userName != null && password != null) {
      return LoginRequestModel(userName: userName, password: password);
    }
    return null;
  }

  Future<void> storeUserCredentials(LoginRequestModel loginRequestModel) async {
    await sharedPreferences.setString("USERNAME", loginRequestModel.userName);
    await sharedPreferences.setString("PASSWORD", loginRequestModel.password);
  }

  Future<bool> getIsAppOpenedFirstTime() async {
    final String? value =
        sharedPreferences.getString("IS_APP_OPENED_FIRST_TIME");

    return value == null;
  }

  Future<void> setIsAppOpenedFirstTime() async {
    await sharedPreferences.setString("IS_APP_OPENED_FIRST_TIME", "true");
  }
}
