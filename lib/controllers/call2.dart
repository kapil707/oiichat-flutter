import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallScreen extends StatefulWidget {
  final String user1;
  final String user2;

  const VideoCallScreen({super.key, required this.user1, required this.user2});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late IO.Socket socket;
  late RTCPeerConnection peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? targetSocketId;

  @override
  void initState() {
    super.initState();
    initRenderers();
    initSocket();
    get_user_2_socket_id(widget.user2);
  }

  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
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
      });
    });

    await setupWebRTC();
  }

  void get_user_2_socket_id(String user2) {
    socket.emit("get_user_2_socket_id", user2);
  }

  Future<void> setupWebRTC() async {
    // Get local audio and video stream
    localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    localRenderer.srcObject = localStream;

    // Configure STUN servers
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    // Create peer connection
    peerConnection = await createPeerConnection(configuration);

    // Add local audio and video tracks
    localStream!.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream!);
    });

    // Handle remote audio and video streams
    peerConnection.onTrack = (event) {
      setState(() {
        remoteStream = event.streams[0];
        remoteRenderer.srcObject = remoteStream;
      });
    };

    // Handle ICE candidates
    peerConnection.onIceCandidate = (candidate) {
      if (targetSocketId != null) {
        socket.emit('signal', {
          'your_id': widget.user1,
          'target': targetSocketId,
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
      'your_id': widget.user1,
      'target': targetSocketId,
      'signal': {'description': offer.toMap()}
    });
    print('Call started 3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                    ),
                    child: RTCVideoView(localRenderer, mirror: true),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                    ),
                    child: remoteStream != null
                        ? RTCVideoView(remoteRenderer)
                        : const Center(
                            child: Text("Waiting for remote video...")),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: startCall,
            child: const Text('Start Call'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    peerConnection.close();
    localStream?.dispose();
    remoteStream?.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }
}
