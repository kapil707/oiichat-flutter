import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VoiceCallScreen extends StatefulWidget {
  final String your_id;
  final String user_id;

  const VoiceCallScreen(
      {super.key, required this.your_id, required this.user_id});

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late IO.Socket socket;
  late RTCPeerConnection peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? mySocketId;
  String? targetSocketId;

  @override
  void initState() {
    super.initState();
    initSocket();
    setState(() {
      mySocketId = widget.your_id;
      targetSocketId = widget.user_id;
    });
  }

  Future<void> initSocket() async {
    // Initialize socket connection
    socket = IO.io(MainConfig.host_url, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit("register", widget.your_id);
      //mySocketId = socket.id;
      //print('My socket ID: $mySocketId');
    });

    // socket.on('user-connected', (id) {
    //   print('User connected: $id');
    //   setState(() {
    //     targetSocketId = id; // Save the target user's socket ID
    //   });
    // });

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

    await setupWebRTC();
  }

  Future<void> setupWebRTC() async {
    // Request microphone permissions
    // var status = await Permission.microphone.request();
    // if (!status.isGranted) {
    //   throw Exception('Microphone permission not granted');
    // }

    // Get local audio stream
    localStream = await navigator.mediaDevices.getUserMedia({'audio': true});

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
          'your_id': widget.your_id,
          'target': targetSocketId,
          'signal': {'candidate': candidate!.toMap()}
        });
      }
    };
  }

  void startCall() async {
    if (targetSocketId == null) {
      print('No target user to call');
      return;
    }

    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    socket.emit('signal', {
      'your_id': widget.your_id,
      'target': targetSocketId,
      'signal': {'description': offer.toMap()}
    });
    print('Call started');
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
