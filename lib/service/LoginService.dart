import 'package:flutter/material.dart';
import 'package:oiichat/config/retrofit_api.dart';

import '../Config/session.dart';

class LoginResponse {
  final String status;
  final String message;

  LoginResponse({required this.status, required this.message});
}

class LoginService {
  final MyApiService apiService;
  LoginService(this.apiService);

  Future<LoginResponse> login_api(BuildContext context, String username,
      String password, String _firebaseToken) async {
    try {
      final response =
          await apiService.login_api("xx", username, password, _firebaseToken);
      //print('login_api:' + response.message.toString());

      final status = response.status.toString();
      final statusMessage = response.message.toString();

      if (status != "1") {
        return LoginResponse(status: status, message: statusMessage);
      }

      if (status == "1") {
        var userId = response.users?.userId;
        var userName = response.users?.userName;

        print('login_api userId:' + userId.toString());

        await Shared.saveLoginSharedPreference(true, userId, userName);
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
