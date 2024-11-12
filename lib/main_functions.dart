
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  Future<Map<String, String>> GetUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userType = prefs.getString('userType') ?? '';
    var userAltercode = prefs.getString('userAltercode') ?? '';
    var userPassword = prefs.getString('userPassword') ?? '';
    var userImage = prefs.getString('userImage') ?? '';
    var userFname = prefs.getString('userFname') ?? '';

    var userNrx = prefs.getString('userNrx') ?? '';
    var ChemistId = prefs.getString('ChemistId') ?? '';
    var userCart = prefs.getString('userCart') ?? '';

    Map<String, String> strings = {};

    strings['userType'] = userType;
    strings['userAltercode'] = userAltercode;
    strings['userPassword'] = userPassword;
    strings['userImage'] = userImage;
    strings['userFname'] = userFname;
    strings['userNrx'] = userNrx;
    strings['ChemistId'] = ChemistId;
    strings['userCart'] = userCart;

    return strings;
  }
}