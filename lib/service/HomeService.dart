import 'package:oiichat/main_functions.dart';
import 'package:oiichat/models/HomePageModel.dart';
import 'package:oiichat/retrofit_api.dart';

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