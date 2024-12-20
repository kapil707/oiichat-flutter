import 'package:flutter/material.dart';
import 'package:oiichat/config/retrofit_api.dart';

import '../config/session.dart';

class LoginResponse {
  final String status;
  final String message;

  LoginResponse({required this.status, required this.message});
}

class LoginService {
  final MyApiService apiService;
  LoginService(this.apiService);

  Future<LoginResponse> registerUserOrLoginUser(
      BuildContext context,
      String uid,
      String type,
      String name,
      String email,
      String image,
      String firebaseToken) async {
    try {
      final response = await apiService.registerUserOrLoginUser_api(
          "xx", uid, type, name, email, image, firebaseToken);

      final status = response.status.toString();
      final statusMessage = response.message.toString();

      if (status != "1") {
        return LoginResponse(status: status, message: statusMessage);
      }

      if (status == "1") {
        var userId = response.users?.userId;
        var userName = response.users?.userName;
        var userImage = response.users?.userImage;

        print('login_api userId:$userId');

        await Shared.saveLoginSharedPreference(
            true, userId, userName, userImage);
        return LoginResponse(status: status, message: "Login successful!");
      }
    } catch (e) {
      return LoginResponse(
          status: "0",
          message: "An error occurred. Please try again. Error: $e");
    }
    return LoginResponse(status: "0", message: "Unexpected error occurred.");
  }

  Future<LoginResponse> login_api(BuildContext context, String username,
      String password, String firebaseToken) async {
    try {
      final response =
          await apiService.login_api("xx", username, password, firebaseToken);
      //print('login_api:' + response.message.toString());

      final status = response.status.toString();
      final statusMessage = response.message.toString();

      if (status != "1") {
        return LoginResponse(status: status, message: statusMessage);
      }

      if (status == "1") {
        var userId = response.users?.userId;
        var userName = response.users?.userName;
        var userImage = response.users?.userImage;

        print('login_api userId:$userId');

        await Shared.saveLoginSharedPreference(
            true, userId, userName, userImage);
        return LoginResponse(status: status, message: "Login successful!");
      }
    } catch (e) {
      return LoginResponse(
          status: "0",
          message: "An error occurred. Please try again. Error: $e");
    }
    // Return a fallback response if no condition matches (should rarely occur)
    return LoginResponse(status: "0", message: "Unexpected error occurred.");
  }
}
