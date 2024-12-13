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
  String? targetSocketId;
  String userA = "A";
  String userB = "B";

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    socket = IO.io(MainConfig.host_url, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('oiicall Connected to server');
      socket.emit('register', userA);
    });

    // Handle incoming call
    socket.on('incoming-call', (data) {
      print('oiicall incoming-call ' + data['userA']);
      setState(() {
        targetSocketId = data['userA'];
      });
    });

    socket.on('accept-call-by-user', (data) async {
      print('oiicall accept-call-by-user ' + data['userA']);

      try {
        if (data['signal']['description'] != null) {
          print('oiicall working1 ' + data['signal']['description']['type']);
          await peerConnection.setRemoteDescription(
            RTCSessionDescription(
              data['signal']['description']['sdp'],
              data['signal']['description']['type'],
            ),
          );

          if (data['signal']['description']['type'] == 'offer') {
            print('oiicall offer');

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
      } catch (e) {
        print('oiicall Error during WebRTC setup: $e');
      }
    });

    socket.on('signal', (data) async {
      print('oiichat signal');
      if (data['signal']['description'] != null) {
        await peerConnection.setRemoteDescription(
          RTCSessionDescription(
            data['signal']['description']['sdp'],
            data['signal']['description']['type'],
          ),
        );

        if (data['signal']['description']['type'] == 'offer') {
          print('oiichat offer');

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
    try {
      // Step 1: Get local audio stream
      localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
      print('oiicall Local audio stream acquired.');

      // Step 2: Configure STUN servers
      final configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'}
        ]
      };

      // Step 3: Create PeerConnection
      peerConnection = await createPeerConnection(configuration);

      // Step 4: Add local audio track to PeerConnection
      localStream!.getTracks().forEach((track) {
        peerConnection.addTrack(track, localStream!);
      });

      // Step 5: Handle remote tracks (audio)
      peerConnection.onTrack = (event) {
        setState(() {
          remoteStream = event.streams[0];
        });
        print('oiicall Remote audio track received.');
      };

      // Step 6: Handle ICE candidates
      peerConnection.onIceCandidate = (candidate) {
        print('oiicall ICE candidate');
        if (userB != null) {
          socket.emit('call-candidate', {
            'userA': userA,
            'userB': userB,
            'signal': {'candidate': candidate.toMap()},
          });
          print('oiicall ICE candidate sent to User B.');
        }
      };

      print('oiicall WebRTC setup completed.');
    } catch (e) {
      print('oiicall Error during WebRTC setup: $e');
    }
  }

  void RequestCall() async {
    try {
      // Step 1: Notify User B about the call
      socket.emit('request-call', {
        'userA': userA, // Caller (User A)
        'userB': userB, // Recipient (User B username)
      });
      print('oiicall Call request sent to User B.');
    } catch (e) {
      print('oiicall Error during call setup: $e');
    }
  }

  void acceptCall() async {
    print('oiicall signal created and sent to User B.');

    setState(() {
      //targetSocketId = incomingCallFrom;
      //incomingCallFrom = null;
    });
    print("oiicall " + targetSocketId!);

    // Step 2: Set up WebRTC
    //await setupWebRTC();

    // Step 3: Create WebRTC offer
    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    print('oiicall WebRTC offer created.');

    socket.emit('accept-call', {
      'userA': userA,
      'userB': userB,
      'signal': {'description': offer.toMap()},
    });
  }

  void declineCall() {
    setState(() {
      //incomingCallFrom = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Call App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Call to " + userB),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: RequestCall,
            ),
          ],
        ),
      ),
    );
  }
}
