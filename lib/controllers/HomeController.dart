import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/AppDrawer.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';

class HomeController extends StatefulWidget {
  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  
  final apiService = MyApiService(Dio());
  late final HomeService homeService;
  bool _isLoading = false;

  String? items0;
  @override
  void initState() {
    super.initState();
    homeService = HomeService(apiService); // Initialize AuthService
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
        title: Text("HomePage"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
          actions: [
            IconButton(onPressed: (){}, 
            icon: Icon(Icons.person))
          ],
      ),drawer: AppDrawer(),
      body: Center(
        child: Text("hello"),
      ),
    );
  }
}