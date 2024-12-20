import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VoiceCallScreen extends StatefulWidget {
  final String user1;
  final String user2;
  final String pickup;

  const VoiceCallScreen(
      {super.key,
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

  @override
  void initState() {
    super.initState();
    initSocket();
    print("oiicall user1 : " + widget.user1 + " user2 : " + widget.user2);
    if (widget.pickup == "yes") {
      Timer(const Duration(seconds: 2), () {
        //startCall();
      });
      print("oiicall startcall");
    }
    get_user_2_socket_id(widget.user2);
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
      print('Connected to server');
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
            'user2': data['sender'],
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
        if (widget.pickup == "yes") {
          startCall();
          print("oiicall startcall");
        }
      });
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
      if (targetSocketId != null) {
        socket.emit('signal', {
          'user1': widget.user1,
          'user2': targetSocketId,
          'signal': {'candidate': candidate.toMap()}
        });
      }
    };
  }

  void startCall() async {
    print('Call started 1');
    if (targetSocketId == null) {
      print('No target user to call');
      return;
    }

    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    print('Call started 2');
    socket.emit('signal', {
      'user1': widget.user1,
      'user2': targetSocketId,
      'signal': {'description': offer.toMap()}
    });
    print('Call started 3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startCall,
              child: const Text('Start Call'),
            ),
            if (remoteStream != null) const Text('Connected to remote stream'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    peerConnection.close();
    localStream?.dispose();
    remoteStream?.dispose();
    super.dispose();
  }
}
