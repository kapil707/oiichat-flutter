import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockService {
  // Wake screen on notification
  static Future<void> wakeScreen() async {
    // Enable wakelock to turn on the screen
    await WakelockPlus.enable();

    // Automatically disable wakelock after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      WakelockPlus.disable();
    });
  }
}
