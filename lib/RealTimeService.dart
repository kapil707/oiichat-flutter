import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'database_helper.dart';

class RealTimeService {
  late IO.Socket socket;
  final dbHelper = DatabaseHelper();

  Function(String)? onMessageReceived;

  void initSocket(String user) {
    // Socket.IO connection setup
    socket = IO.io('http://192.168.1.7:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Listen for server events
    socket.on('connect', (_) {
        print('Connected to the server');
        socket.emit("register", user);
    });
    // Handle disconnection
    socket.on('disconnect', (_) => print('Disconnected from server'));

    socket.on('receiveMessage', (data) async {
      print("Message received: ${data["message"]}");
      
      await dbHelper.insertMessage({
        'user1': data['user1'],
        'user2': data['user2'],
        'message': data['message'],
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (onMessageReceived != null) {
        onMessageReceived!(data["message"]); // Pass the raw string to the callback
      }
    });
  }

  void manual_disconnect(String user) {
    socket.emit("manual_disconnect", user);
  }

  void sendMessage(String user1,String user2,String message) { 
      socket.emit('sendMessage', {
        'user1': user1,
        'user2': user2,
        'message': message,
      });

      // Save the sent message locally
      dbHelper.insertMessage({
        'user1': user1,
        'user2': user2,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
  }

  void dispose() {
    socket.disconnect();
    socket.close();
  }
}
