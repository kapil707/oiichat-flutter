import 'package:oiichat/models/HomePageModel.dart';
import 'package:oiichat/config/retrofit_api.dart';

import '../config/main_functions.dart';

class HomeService {
  final MyApiService apiService;
  HomeService(this.apiService);

  Future<HomePageModel> fetchHomePage() async {
    try {
      UserSession userSession = UserSession();
      Map<String, String> userSessionData = await userSession.GetUserSession();

      var userId = userSessionData['userId']!;

      final response = await apiService.home_page_api("xx");
      print(response.status);
      return response; // Return the fetched data
    } catch (error) {
      print('Error fetching notifications: $error');
      rethrow; // Re-throw to allow error handling outside this function
    }
  }
}
