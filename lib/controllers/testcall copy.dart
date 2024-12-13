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
      setState(() {
        incomingCallFrom = data['userA'];
      });
    });

    socket.on('signal', (data) async {
      final signal = data['signal'];
      if (signal['type'] == 'offer') {
        print('oiicall offer');
        await peerConnection.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signal['type']),
        );
        final answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);
        //socket.emit('signal', {'to': data['from'], 'signal': answer.toMap()});
      } else if (signal['type'] == 'answer') {
        print('oiicall answer');
        await peerConnection.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signal['type']),
        );
      } else if (signal['candidate'] != null) {
        await peerConnection.addCandidate(
          RTCIceCandidate(signal['candidate'], '', 0),
        );
      }
    });
  }

  void RequestCall() async {
    try {
      // Step 1: Initialize WebRTC connection
      peerConnection = await createPeerConnection({
        "iceServers": [
          {"urls": "stun:stun.l.google.com:19302"} // STUN server for ICE
        ]
      });

      // Step 2: Get local audio stream and add it to the peer connection
      MediaStream localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
      localStream.getTracks().forEach((track) {
        peerConnection.addTrack(track, localStream);
      });

      // Step 3: Create an offer
      RTCSessionDescription offer = await peerConnection.createOffer();

      // Step 4: Set the offer as the local description
      await peerConnection.setLocalDescription(offer);

      // Step 5: Send the offer to the signaling server
      socket.emit('request-call', {
        'userA': myUsername, // User A's username
        'userB': callToController.text, // User B's username
      });

      socket.emit('signal', {
        'userA': myUsername,
        'userB': callToController.text,
        'signal': offer.toMap(), // Send the SDP offer
      });

      //print('oiicall Offer created and sent to User B.' + offer.toMap().toString());
      print('oiicall Offer created and sent to User B.');

    } catch (e) {
      print('oiicall Error initializing WebRTC: $e');
    }
  }

  void acceptCall() async {
    // Step 1: Initialize WebRTC connection
    peerConnection = await createPeerConnection({
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"} // STUN server for ICE
      ]
    });

    // Step 2: Get local audio stream and add it to the peer connection
    MediaStream localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
    localStream.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream);
    });

    // Step 3: Set the remote description (offer received from User A)
    // await peerConnection.setRemoteDescription(
    //     RTCSessionDescription(
    //         receivedOffer['sdp'],
    //         receivedOffer['type'])
    // );

    // Step 4: Create an answer
    RTCSessionDescription answer = await peerConnection.createAnswer();

    // Step 5: Set the answer as the local description
    await peerConnection.setLocalDescription(answer);

    // Step 6: Send the answer back to User A via the signaling server
    socket.emit('signal', {
      'to': incomingCallFrom, // User A's username
      'signal': answer.toMap(), // Send the SDP answer
    });

    print('Call accepted and answer sent to User A.');

    setState(() {
      incomingCallFrom = null;
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