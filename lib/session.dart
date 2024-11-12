import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static String loginSharedPreference = "drdlite";

  // save data

  static Future<bool> saveLoginSharedPreference(
                islogin,
                user_type,
                user_code,
                user_altercode,
                user_password,
                user_image,
                user_fname,
                user_nrx,
                user_cart) async {
    //SharedPreferences.setMockInitialValues({});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginSharedPreference, islogin);
    await prefs.setString("user_type", user_type);
    await prefs.setString("user_code", user_code);
    await prefs.setString("user_altercode", user_altercode);
    await prefs.setString("user_password", user_password);
    await prefs.setString("user_fname", user_fname);
    await prefs.setString("user_image", user_image);
    await prefs.setString("user_nrx", user_nrx);
    await prefs.setString("user_cart", user_cart);

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
