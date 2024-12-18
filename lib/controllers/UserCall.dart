import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OutGoingCallScreen extends StatefulWidget {
  final String UserName;
  final String UserImage;
  final String user1;
  final String user2;
  final String calltype;

  const OutGoingCallScreen({
    Key? key,
    required this.UserName,
    required this.UserImage,
    required this.user1,
    required this.user2,
    required this.calltype,
  }) : super(key: key);

  @override
  State<OutGoingCallScreen> createState() => _OutGoingCallScreenState();
}

class _OutGoingCallScreenState extends State<OutGoingCallScreen> {
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
    _realTimeService.initSocket(widget.user1);
    //jab user1 user2 ko call karta ha
    _realTimeService.request_call(widget.user1, widget.user2);

    _realTimeService.onRejectCallByUser = (data) {
      print("oiicall onRejectCallByUser");
      Navigator.pop(context, true);
    };
  }

  Future<void> initSocket() async {
    socket = IO.io(MainConfig.host_url, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('oiicall Connected to server');
      socket.emit('register', widget.user1);
    });

    // Handle incoming call
    //step 2
    // socket.on('incoming-call', (data) {
    //   print('oiicall incoming-call ' + data['user1']);
    //   setState(() {
    //     targetSocketId = data['userA'];
    //   });
    // });
    //step 4
    // socket.on('accept-call-by-user', (data) async {
    //   print('oiicall accept-call-by-user ' + data['user1']);
    // });
  }

  void cancelCall(BuildContext context) {
    //print('Call Declined');
    //jiss user nay call ki ha agar wo he call cut karta ha to
    _realTimeService.request_call_cancel(widget.user1, widget.user2);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
              '${widget.calltype}',
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
}

class IncomingCallScreen extends StatefulWidget {
  final String user1;
  final String user2;
  final String callerName;
  //final VoidCallback onAccept;
  //final VoidCallback onDecline;

  const IncomingCallScreen({
    Key? key,
    required this.user1,
    required this.user2,
    required this.callerName,
  }) : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final RealTimeService _realTimeService = RealTimeService();

  @override
  void initState() {
    super.initState();
    _realTimeService.initSocket(widget.user1);
  }

  void onAccept(BuildContext context) {
    //print('Call Declined');
    Navigator.pop(context, true);
  }

  void onDecline(BuildContext context) {
    print('oiicall Call Declined');
    _realTimeService.request_call_reject(widget.user1, widget.user2);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_in_talk, size: 100, color: Colors.green),
          const SizedBox(height: 20),
          Text(
            '${widget.callerName} is calling...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => onAccept(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.call, color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => onDecline(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.call_end, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
