import 'package:shared_preferences/shared_preferences.dart';

const _customerAccessTokenKey = 'customer-access-token';

class Store {
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerAccessTokenKey);
  }

  static Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_customerAccessTokenKey, accessToken);
  }
}