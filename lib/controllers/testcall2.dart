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

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController callToController = TextEditingController();
  String? myUsername;
  String? incomingCallFrom;
  String? targetSocketId;

  @override
  void initState() {
    super.initState();
    initializeSocket();
  }

  void initializeSocket() {
    socket = IO.io(MainConfig.host_url, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('oiicall Connected to server');
    });

    // Handle incoming call
    socket.on('incoming-call', (data) {
      print('oiicall incoming-call ' + data['userA']);
      setState(() {
        incomingCallFrom = targetSocketId = data['userA'];
      });
    });

    socket.on('accept-call-by-user', (data) async {
      print('oiicall accept-call-by-user ' + data['userA']);

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
  }

  Future<void> setupWebRTC() async {
    try {
      // Step 1: Get local audio stream
      localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
      print('oiichat Local audio stream acquired.');

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
        print('Remote audio track received.');
      };

      // Step 6: Handle ICE candidates
      peerConnection.onIceCandidate = (candidate) {
        if (targetSocketId != null) {
          socket.emit('signal', {
            'userA': myUsername,
            'userB': targetSocketId,
            'signal': {'candidate': candidate.toMap()},
          });
          print('ICE candidate sent to User B.');
        }
      };

      print('WebRTC setup completed.');
    } catch (e) {
      print('Error during WebRTC setup: $e');
    }
  }

  void RequestCall() async {
    try {
      // Step 1: Notify User B about the call
      socket.emit('request-call', {
        'userA': myUsername, // Caller (User A)
        'userB': callToController.text, // Recipient (User B username)
      });
      print('oiicall Call request sent to User B.');
    } catch (e) {
      print('oiicall Error during call setup: $e');
    }
  }

  void acceptCall() async {
    print('oiicall signal created and sent to User B.');

    setState(() {
      targetSocketId = incomingCallFrom;
      incomingCallFrom = null;
    });
    print("oiicall " + targetSocketId!);

    // Step 2: Set up WebRTC
    await setupWebRTC();

    // Step 3: Create WebRTC offer
    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    print('oiicall WebRTC offer created.');

    socket.emit('accept-call', {
      'userA': myUsername,
      'userB': targetSocketId,
      'signal': {'description': offer.toMap()},
    });
  }

  void declineCall() {
    setState(() {
      incomingCallFrom = null;
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
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Your Username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    myUsername = usernameController.text;
                    socket.emit('register', myUsername);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: callToController,
              decoration: InputDecoration(
                labelText: 'Call To (Username)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: RequestCall,
                ),
              ),
            ),
            if (incomingCallFrom != null)
              AlertDialog(
                title: Text('Incoming Call'),
                content: Text('$incomingCallFrom is calling you.'),
                actions: [
                  TextButton(
                    onPressed: acceptCall,
                    child: const Text('Accept'),
                  ),
                  TextButton(
                    onPressed: declineCall,
                    child: const Text('Decline'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
