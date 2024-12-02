import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VoiceCallScreen extends StatefulWidget {
  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late IO.Socket socket;
  late RTCPeerConnection peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  bool isInitialized = false;
  @override
  void initState() {
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    // Initialize socket connection
    socket = IO.io(MainConfig.host_url, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected to the server');
    });

    socket.on('signal', (data) async {
      print('Signal received: $data');
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
            'target': 'C7CrlFnIFIcr6bcpAAAD',
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

    // Get local audio stream
    localStream = await navigator.mediaDevices.getUserMedia({'audio': true});

    // Initialize peer connection
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };
    peerConnection = await createPeerConnection(configuration);

    // Add local stream tracks
    localStream!.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream!);
    });

    // Handle remote stream
    peerConnection.onTrack = (event) {
      setState(() {
        remoteStream = event.streams[0];
      });
    };

    // Handle ICE candidates
    peerConnection.onIceCandidate = (candidate) {
      socket.emit('signal', {
        'signal': {'candidate': candidate!.toMap()}
      });
    };

    setState(() {
      isInitialized = true;
    });
  }

  void startCall() async {
    if (!isInitialized) {
      print('PeerConnection is not yet initialized.');
      return;
    }

    // Create offer and send to signaling server
    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    socket.emit('signal', {
      'signal': {'description': offer.toMap()}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Call'),
      ),
      body: Center(
        child: isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: startCall,
                    child: Text('Start Call'),
                  ),
                  if (remoteStream != null) Text('Connected to remote stream'),
                ],
              )
            : CircularProgressIndicator(), // Show loader until WebRTC setup is complete
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