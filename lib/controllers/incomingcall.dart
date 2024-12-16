/*import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';

class Incomingcall extends StatefulWidget {
  const Incomingcall({super.key});

  @override
  State<Incomingcall> createState() => _IncomingcallState();
}

class _IncomingcallState extends State<Incomingcall> {
  @override
  void initState() {
    super.initState();
    initializeCallKit();
  }

  Future<void> initializeCallKit() async {
    const uuid = '12345'; // Unique ID for the call
    const nameCaller = 'John Doe';
    const handle = '123456789'; // Phone number or identifier

    // Configure settings for the CallKit
    await FlutterCallkitIncoming.showCallkitIncoming({
      'id': uuid, // Unique call ID
      'nameCaller': nameCaller, // Caller Name
      'handle': handle, // Caller handle (phone/username)
      'type': 0, // Audio call
      'textAccept': 'Accept',
      'textDecline': 'Decline',
      'textMissedCall': 'Missed Call',
      'duration': 30000, // 30 seconds
    } as CallKitParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter CallKit Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: simulateIncomingCall,
          child: const Text('Simulate Incoming Call oii'),
        ),
      ),
    );
  }

  Future<void> simulateIncomingCall() async {
    const uuid = '12345'; // Unique ID for the call
    const nameCaller = 'John Doe';
    const handle = '123456789'; // Phone number or identifier

    try {
      // Create a CallKitParams object
      final callKitParams = CallKitParams(
        id: "12345", // Unique ID for the call
        nameCaller: "John Doe", // Caller's name
        handle: "123456789", // Phone number or identifier
        type: 0, // 0 for audio, 1 for video
        duration: 30000, // Call duration in milliseconds
        textAccept: "Accept", // Text for the accept button
        textDecline: "Decline", // Text for the decline button
      );

      // Show incoming call using CallKitParams
      await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);

      print("Incoming call displayed successfully.");
    } catch (e) {
      print("Error showing incoming call: $e");
    }
  }
}*/
