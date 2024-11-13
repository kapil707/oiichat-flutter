import 'package:flutter/material.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/models/HomePageModel.dart';
import 'package:oiichat/retrofit_api.dart';

class HomeController {  
  
  final MyApiService apiService;
  HomeController(this.apiService);

  /*Future<List<HomePageModel>> homePageLoad(BuildContext context, String seqId) async {

    print("work");

    /*UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();

    var userType = userSessionData['userType']!;
    var userAltercode = userSessionData['userAltercode']!;
    var userPassword = userSessionData['userPassword']!;
    var chemistId = userSessionData['ChemistId']!;
    var userNrx = userSessionData['userNrx']!;

    try {
      final response = await apiService.home_page_api(
        "xx", userType, userAltercode, userPassword, chemistId, userNrx, seqId,
      );

      if (response.success == "1") {
        return response.items;
      } else {
        print("Error: ${response.message}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }*/
  } */
}