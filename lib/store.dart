

import 'package:shared_preferences/shared_preferences.dart';

const _user = 'user';

class Store {
  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_user);
  }

  static Future<void> saveUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_user, userId);
  }
}