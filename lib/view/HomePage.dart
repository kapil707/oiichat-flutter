import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/controllers/HomeController.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/retrofit_api.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final apiService = MyApiService(Dio());
  late final HomeController authService;
  bool _isLoading = false;

  String? items0;
  @override
  void initState() {
    super.initState();
    authService = HomeController(apiService); // Initialize AuthService
    _handlePageLoad();
  }

  Future<void> _handlePageLoad() async {
     setState(() {
      _isLoading = true;
    });
    UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();

    var userType = userSessionData['userType']!;
    var userAltercode = userSessionData['userAltercode']!;
    var userPassword = userSessionData['userPassword']!;
    var chemistId = userSessionData['ChemistId']!;
    var userNrx = userSessionData['userNrx']!;

  final response = await apiService.home_page_api(
        "xx", userType, userAltercode, userPassword, chemistId, userNrx,"1"
      );
    items0 = response.items?.first.itemId;
    print(response.items?.first.itemId);
    if(response.success=="1"){
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [ Text("HomePage"),
          if (_isLoading)...{
              Center(
                child: CircularProgressIndicator(),
            ),
          },
        ]),
      ),
      body: Center(
        child: Text("hello"),
      ),
    );
  }
}