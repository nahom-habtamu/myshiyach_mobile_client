import 'dart:io';

class NetworkInfo {
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      throw Exception();
    } catch (e) {
      return false;
    }
  }
}
