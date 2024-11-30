import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static String loginSharedPreference = "OiiChatNew";

  // save data

  static Future<bool> saveLoginSharedPreference(
                islogin,
                userId,
                userName) async {
    //SharedPreferences.setMockInitialValues({});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginSharedPreference, islogin);
    await prefs.setString("userId", userId);
    await prefs.setString("userName", userName);

    return true;
  }

  //fetch data

  static Future getUserSharedPreferences() async {
    //SharedPreferences.setMockInitialValues({});

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(loginSharedPreference);
  }

  static Future<bool> logout() async {
    //SharedPreferences.setMockInitialValues({});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(loginSharedPreference);
  }
}
