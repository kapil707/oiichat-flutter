import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockService {
  // Wake screen on notification
  static Future<void> wakeScreen() async {
    print('wakeScreen');
    try {
      // Enable wakelock to turn on the screen
      await WakelockPlus.enable();

      // Automatically disable wakelock after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        WakelockPlus.disable();
      });
    } catch (e) {
      print('Error enabling wakelock: $e');
    }
  }
}

class WakelockPlusExampleApp extends StatefulWidget {
  const WakelockPlusExampleApp({super.key});

  /// Creates the [WakelockPlusExampleApp] widget.

  @override
  State<WakelockPlusExampleApp> createState() => _WakelockPlusExampleAppState();
}

class _WakelockPlusExampleAppState extends State<WakelockPlusExampleApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wakelock example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Spacer(
                flex: 3,
              ),
              OutlinedButton(
                onPressed: () {
                  // The following code will enable the wakelock on the device
                  // using the wakelock plugin.
                  setState(() {
                    WakelockPlus.enable();
                    // You could also use Wakelock.toggle(on: true);
                  });
                },
                child: const Text('enable wakelock'),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  // The following code will disable the wakelock on the device
                  // using the wakelock plugin.
                  setState(() {
                    WakelockPlus.disable();
                    // You could also use Wakelock.toggle(on: false);
                  });
                },
                child: const Text('disable wakelock'),
              ),
              const Spacer(
                flex: 2,
              ),
              FutureBuilder(
                future: WakelockPlus.enabled,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  final data = snapshot.data;
                  // The use of FutureBuilder is necessary here to await the
                  // bool value from the `enabled` getter.
                  if (data == null) {
                    // The Future is retrieved so fast that you will not be able
                    // to see any loading indicator.
                    return Container();
                  }

                  return Text('The wakelock is currently '
                      '${data ? 'enabled' : 'disabled'}.');
                },
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
