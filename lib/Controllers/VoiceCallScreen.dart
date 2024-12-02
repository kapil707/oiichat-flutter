import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/controllers/VoiceCall.dart';

class CallScreen extends StatefulWidget {
  final String userId;
  final String otherUserId;

  const CallScreen({super.key, required this.userId, required this.otherUserId});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final RealTimeServiceVoiceCall _realTimeService = RealTimeServiceVoiceCall();
  MediaStream? _remoteStream;

  @override
  void initState() {
    super.initState();

    _realTimeService.initSocket(widget.userId);

    _realTimeService.onIncomingCall = (caller) {
      _showIncomingCallDialog(caller);
    };

    _realTimeService.onRemoteStream = (stream) {
      setState(() {
        _remoteStream = stream;
      });
    };
  }

  void _showIncomingCallDialog(String caller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Incoming Call"),
          content: Text("$caller is calling you"),
          actions: [
            TextButton(
              onPressed: () {
                _realTimeService.acceptCall(caller);
                Navigator.pop(context);
              },
              child: Text("Accept"),
            ),
            TextButton(
              onPressed: () {
                _realTimeService.rejectCall(caller);
                Navigator.pop(context);
              },
              child: Text("Reject"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _realTimeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Call")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _realTimeService.callUser(widget.userId, widget.otherUserId);
            },
            child: Text("Call ${widget.otherUserId}"),
          ),
          if (_remoteStream != null)
            Expanded(
              child: RTCVideoView(
                RTCVideoRenderer()
                  ..srcObject = _remoteStream!
              ),
            )
        ],
      ),
    );
  }
}