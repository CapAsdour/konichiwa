import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManagement {
  static SharedPreferences sharedPref;
  static const String KEY_UID = 'uid';
  static const String KEY_EMAIL = 'email';
  static const String KEY_LOGGED = 'isLogin';
  static void storeUserCredentials(String email) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(KEY_EMAIL, email);
  }

  static void storeLogin({@required String uid}) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(KEY_LOGGED, true);
    sharedPref.setString(KEY_UID, uid);
  }

  static Future<bool> getLoginStatus() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool(KEY_LOGGED) ?? false;
  }

  static Future<String> getLoginUID() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(KEY_UID) ?? '';
  }

  static Future<bool> removeUser() async {
    sharedPref = await SharedPreferences.getInstance();
    //return sharedPref.remove(KEY_UID);  //for particular value
    return sharedPref.clear();
  }
}
