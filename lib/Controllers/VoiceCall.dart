import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RealTimeServiceVoiceCall {
  late IO.Socket _socket;
  final _peerConnectionConfig = {
    "iceServers": [
      {"urls": "stun:stun.l.google.com:19302"}
    ]
  };

  RTCPeerConnection? _peerConnection;
  Function? onIncomingCall;
  Function? onCallResponse;
  Function? onRemoteStream;

  void initSocket(String userId) {
    _socket = IO.io(MainConfig.host_url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.on('connect', (_) {
      print("Connected to signaling server");
      _socket.emit('register', userId);
    });

    _socket.on('incomingCall', (data) {
      print("Incoming call from: ${data['caller']}");
      if (onIncomingCall != null) {
        onIncomingCall!(data['caller']);
      }
    });

    _socket.on('callAccepted', (_) {
      print("Call accepted");
      _createPeerConnection();
    });

    _socket.on('offer', (data) async {
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(data['sdp'], 'offer'),
      );
      final answer = await _peerConnection?.createAnswer();
      await _peerConnection?.setLocalDescription(answer!);
      _socket.emit('answer', {'sdp': answer!.sdp});
    });

    _socket.on('answer', (data) async {
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(data['sdp'], 'answer'),
      );
    });

    _socket.on('iceCandidate', (data) {
      _peerConnection?.addCandidate(
        RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ),
      );
    });
  }

  void callUser(String callerId, String calleeId) {
    _socket.emit('call', {'caller': callerId, 'callee': calleeId});
  }

  void acceptCall(String callerId) {
    _socket.emit('callResponse', {'caller': callerId, 'accepted': true});
    _createPeerConnection();
  }

  void rejectCall(String callerId) {
    _socket.emit('callResponse', {'caller': callerId, 'accepted': false});
  }

  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(_peerConnectionConfig);

    _peerConnection!.onIceCandidate = (candidate) {
      _socket.emit('iceCandidate', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    _peerConnection!.onAddStream = (stream) {
      if (onRemoteStream != null) {
        onRemoteStream!(stream);
      }
    };

    final mediaStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
    });
    _peerConnection?.addStream(mediaStream);
  }

  void dispose() {
    _peerConnection?.close();
    _socket.dispose();
  }
}
