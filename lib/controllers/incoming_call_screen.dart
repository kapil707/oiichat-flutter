import 'package:flutter/material.dart';

class IncomingCallScreen extends StatelessWidget {
  final String callerId;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const IncomingCallScreen({
    Key? key,
    required this.callerId,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Incoming Call from $callerId',
                style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: onReject,
                  child: const Text('Reject'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
