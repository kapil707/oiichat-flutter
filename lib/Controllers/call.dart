import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VoiceCallScreen extends StatefulWidget {
  final String UserName;
  final String UserImage;
  final String user1;
  final String user2;
  final String pickup;

  const VoiceCallScreen(
      {super.key,
      required this.UserName,
      required this.UserImage,
      required this.user1,
      required this.user2,
      required this.pickup});

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  final RealTimeService _realTimeService = RealTimeService();
  late IO.Socket socket;
  late RTCPeerConnection peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? targetSocketId;
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    initSocket();
    print("oiicall user1 : " + widget.user1 + " user2 : " + widget.user2);
    if (widget.pickup == "yes") {
      Timer(const Duration(seconds: 2), () {
        //startCall();
        get_user_2_socket_id(widget.user2);
      });
      print("oiicall startcall");
    } else {
      startTimer();
    }
  }

  void get_user_2_socket_id(String user2) {
    //print("get_user_2_socket_id");
    socket.emit("get_user_2_socket_id", user2);
  }

  Future<void> initSocket() async {
    // Initialize socket connection
    socket = IO.io(MainConfig.host_url, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('oiicall Connected to server');
      socket.emit("register", widget.user1);
    });

    socket.on('signal', (data) async {
      if (data['signal']['description'] != null) {
        await peerConnection.setRemoteDescription(
          RTCSessionDescription(
            data['signal']['description']['sdp'],
            data['signal']['description']['type'],
          ),
        );

        if (data['signal']['description']['type'] == 'offer') {
          final answer = await peerConnection.createAnswer();
          await peerConnection.setLocalDescription(answer);

          socket.emit('signal', {
            'target': data['sender'],
            'signal': {'description': answer.toMap()}
          });
        }
      }

      if (data['signal']['candidate'] != null) {
        await peerConnection.addCandidate(
          RTCIceCandidate(
            data['signal']['candidate']['candidate'],
            data['signal']['candidate']['sdpMid'],
            data['signal']['candidate']['sdpMLineIndex'],
          ),
        );
      }
    });

    socket.on('get_user_2_socket_id_response', (data) async {
      setState(() {
        targetSocketId = data["user2"];
        startCall();
        startTimer();
      });
    });

    socket.on('cut-call-by-user', (data) async {
      Navigator.pop(context, true);
    });

    await setupWebRTC();
  }

  Future<void> setupWebRTC() async {
    // Get local audio stream
    localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
    });

    // Configure STUN servers
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    // Create peer connection
    peerConnection = await createPeerConnection(configuration);

    // Add local audio stream
    localStream!.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream!);
    });

    // Handle remote audio stream
    peerConnection.onTrack = (event) {
      setState(() {
        remoteStream = event.streams[0];
      });
      print('Remote track received');
    };

    // Handle ICE candidates
    peerConnection.onIceCandidate = (candidate) {
      socket.emit('signal', {
        'user1': widget.user1,
        'target': targetSocketId,
        'signal': {'candidate': candidate.toMap()}
      });
    };
  }

  void startCall() async {
    print('Call started 1');
    // if (targetSocketId == null) {
    //   print('No target user to call');
    //   return;
    // }

    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    print('Call started 2');
    socket.emit('signal', {
      'user1': widget.user1,
      'target': targetSocketId,
      'signal': {'description': offer.toMap()}
    });
    print('Call started 3');
  }

  void cancelCall(BuildContext context) {
    _realTimeService.request_call_cut(widget.user1, widget.user2);
    Navigator.pop(context, true);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60; // Get the total minutes
    final remainingSeconds = seconds % 60; // Get the remaining seconds
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Voice Call'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         ElevatedButton(
    //           onPressed: startCall,
    //           child: const Text('Start Call'),
    //         ),
    //         if (remoteStream != null) const Text('Connected to remote stream'),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Text(
              '${widget.UserName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              formatTime(_secondsElapsed),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            const Icon(Icons.phone_in_talk, size: 100, color: Colors.green),
            const Spacer(),
            ClipOval(
              child: Image.network(
                widget.UserImage,
                width: 250, // Set the custom width
                height: 250, // Set the custom height
                fit: BoxFit.cover, // Ensures the image fills the circle
              ),
            ),
            const Spacer(), // Pushes everything above to the top
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () => cancelCall(context), // Fix here,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.call_end, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    socket.dispose();
    peerConnection.close();
    localStream?.dispose();
    remoteStream?.dispose();
    super.dispose();
  }
}
