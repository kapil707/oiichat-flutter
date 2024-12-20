import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:oiichat/controllers/call.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _realTimeService.initSocket(widget.user1);

    //jab user1 user2 ko call karta ha
    _realTimeService.request_call(widget.user1, widget.user2);

    _realTimeService.onRejectCallByUser = (data) {
      print("oiicall onRejectCallByUser");
      Navigator.pop(context, true);
    };

    _realTimeService.onAcceptCallByUser = (data) {
      print("oiicall onAcceptCallByUser");
      //Navigator.pop(context, true);
      _audioPlayer.stop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => VoiceCallScreen(
                  user1: widget.user1, user2: widget.user2, pickup: "yes")));
    };
    playIncomingCall();
  }

  void playIncomingCall() async {
    try {
      await _audioPlayer.play(AssetSource('calling.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void cancelCall(BuildContext context) {
    //print('Call Declined');
    //jiss user nay call ki ha agar wo he call cut karta ha to
    _realTimeService.request_call_cancel(widget.user1, widget.user2);
    _audioPlayer.stop();
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
  final String UserName;
  final String UserImage;
  //final VoidCallback onAccept;
  //final VoidCallback onDecline;

  const IncomingCallScreen({
    Key? key,
    required this.user1,
    required this.user2,
    required this.UserName,
    required this.UserImage,
  }) : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final RealTimeService _realTimeService = RealTimeService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _realTimeService.initSocket(widget.user1);

    _realTimeService.onIncomingCallCancel = (data) {
      print("oiicall onIncomingCallCancel");
      Navigator.pop(context, true);
    };

    playIncomingCall();
  }

  void playIncomingCall() async {
    try {
      await _audioPlayer.play(AssetSource('incoming-call.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void onAccept(BuildContext context) {
    //print('Call Declined');
    _realTimeService.request_call_accept(widget.user1, widget.user2);
    _audioPlayer.stop();
    //Navigator.pop(context, true);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => VoiceCallScreen(
                user1: widget.user1, user2: widget.user2, pickup: "no")));
  }

  void onDecline(BuildContext context) {
    _realTimeService.request_call_reject(widget.user1, widget.user2);
    _audioPlayer.stop();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Text(
            'Oii Audio Call',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${widget.UserName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          const Icon(Icons.phone_in_talk, size: 100, color: Colors.green),
          const SizedBox(height: 40),
          ClipOval(
            child: Image.network(
              widget.UserImage,
              width: 250, // Set the custom width
              height: 250, // Set the custom height
              fit: BoxFit.cover, // Ensures the image fills the circle
            ),
          ),
          const Spacer(),
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
