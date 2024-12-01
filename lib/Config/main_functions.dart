import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  Future<Map<String, String>> GetUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('userId') ?? '';
    var userName = prefs.getString('userName') ?? '';
    var userImage = prefs.getString('userImage') ?? '';

    Map<String, String> strings = {};

    strings['userId'] = userId;
    strings['userName'] = userName;
    strings['userImage'] = userImage;

    return strings;
  }
}
