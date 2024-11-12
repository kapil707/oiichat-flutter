import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/session.dart';
import 'package:oiichat/view/home_page.dart';

class LoginController {  
  
  final MyApiService apiService;

  LoginController(this.apiService);

  Future<String?> login(BuildContext context, String username, String password) async {

    try {
      final response = await apiService.get_login_api("xx", username, password, "");
      final status = response.items?.first.status;
      final statusMessage = response.items?.first.statusMessage;

      if (status != "1") {
        return statusMessage;
      }
      if (status == "1") {

        var userSession = response.items?.first.userSession;
        var userFname = response.items?.first.userFname;
        var userCode = response.items?.first.userCode;
        var userAltercode = response.items?.first.userAltercode;
        var userType = response.items?.first.userType;
        var userPassword = response.items?.first.userPassword;
        var userImage = response.items?.first.userImage;
        var userNrx = response.items?.first.userNrx;
        var userCart = 0;

        Shared.saveLoginSharedPreference(
              true,
              userType,
              userCode,
              userAltercode,
              userPassword,
              userImage,
              userFname,
              userNrx,
              userCart)
              .then((value) {});

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home_Page(),
            ),
          );

        return "Login successful!";
      }
    } catch (e) {
      return e.toString() + "An error occurred. Please try again.";
    }
  }
}