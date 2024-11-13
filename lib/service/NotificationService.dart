import 'package:oiichat/main_functions.dart';
import 'package:oiichat/models/NotificationModel.dart';
import 'package:oiichat/retrofit_api.dart';

class NotificationService {  
  
  final MyApiService apiService;
  NotificationService(this.apiService);

  Future<NotificationModel> fetchNotifications() async {
    try {
      UserSession userSession = UserSession();
      Map<String, String> userSessionData = await userSession.GetUserSession();

      var userType = userSessionData['userType']!;
      var userAltercode = userSessionData['userAltercode']!;
      var userPassword = userSessionData['userPassword']!;
      var chemistId = userSessionData['ChemistId']!;
      var userNrx = userSessionData['userNrx']!;
      
      print("userAltercode: $userAltercode");

      final response = await apiService.my_notification_api(
        "xx", userType, userAltercode, userPassword, chemistId, userNrx, "10"
      );

      print(userType); // Print the raw response data
      return response; // Return the fetched data
    } catch (error) {
      print('Error fetching notifications: $error');
      rethrow; // Re-throw to allow error handling outside this function
    }
  }
}