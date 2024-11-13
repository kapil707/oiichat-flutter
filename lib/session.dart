import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static String loginSharedPreference = "drdlite";

  // save data

  static Future<bool> saveLoginSharedPreference(
                islogin,
                userCode,
                userType,
                userAltercode,
                userPassword,
                userFname,
                userImage,
                userNrx,
                userCart) async {
    //SharedPreferences.setMockInitialValues({});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginSharedPreference, islogin);
    await prefs.setString("userCode", userCode);
    await prefs.setString("userType", userType);
    await prefs.setString("userAltercode", userAltercode);
    await prefs.setString("userPassword", userPassword);
    await prefs.setString("userFname", userFname);
    await prefs.setString("userImage", userImage);
    await prefs.setString("userNrx", userNrx);
    await prefs.setString("userCart", userCart);

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
