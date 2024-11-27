import 'package:oiichat/models/message.dart';
import 'package:oiichat/models/useri_info_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'database_helper.dart';
import 'dart:math';

String generateRandomToken(int length) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join();
}

class RealTimeService {
  late IO.Socket socket;
  final dbHelper = DatabaseHelper();

  Function(String)? onMessageSend;
  Function(String)? onMessageReceived;

  void initSocket(String user) {
    // Socket.IO connection setup
    socket = IO.io('http://160.30.100.216:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Listen for server events
    socket.on('connect', (_) {
      print('Connected to the server');
      socket.emit("register", user);
      check_offline_message(user);
    });
    // Handle disconnection
    socket.on('disconnect', (_) => print('Disconnected from server'));

    socket.on('receiveMessage', (data) async {
      print("user ka naam " + data["name"]);
      //user ki info insert or update hotai ha yaha say
      final newUser = UseriInfoModel(
        user_id: data["user1"],
        user_name: data["name"],
      );
      await dbHelper.insertOrUpdateUserInfo(newUser);

      final newMessage = Message(
        user1: data["user1"],
        user2: data["user2"],
        message: data["message"],
        status: 1,
        timestamp: DateTime.now().toIso8601String(),
      );
      await dbHelper.insertMessage(newMessage);

      if (onMessageReceived != null) {
        onMessageReceived!(
            data["message"]); // Pass the raw string to the callback
      }
    });

    socket.on('messageSent', (data) async {
      if (data['status'] == 'success') {
        print(
            'Message sent successfully: ${data['token']} ${data['messageId']}');
        var id = data['messageId'];
        await dbHelper.updateMessageStatus(id, 1);
        print(
            'Message sent successfully: ${data['token']} ${data['messageId']}');
        onMessageSend!("1");
      }
    });
  }

  void manual_disconnect(String user) {
    socket.emit("manual_disconnect", user);
  }

  void sendMessage(String user1, String user2, String message) async {
    final newMessage = Message(
      user1: user1,
      user2: user2,
      message: message,
      status: 0,
      timestamp: DateTime.now().toIso8601String(),
    );
    int insertedId = await dbHelper.insertMessage(newMessage);

    socket.emit('sendMessage', {
      'user1': user1,
      'user2': user2,
      'message': message,
      'token': generateRandomToken(16),
      'messageId': insertedId,
    });
  }

  // jab message nahi gaya ha oss ko resend karta ha yha
  void check_offline_message(String user) async {
    print("call check_offline_message");
    final chatHistory = await dbHelper.check_offline_message(user);
    for (var messages in chatHistory) {
      print("msg " + messages.id.toString());
      socket.emit('sendMessage', {
        'user1': messages.user1,
        'user2': messages.user2,
        'message': messages.message,
        'token': generateRandomToken(16),
        'messageId': messages.id,
      });

      //check_offline_message(user);
    }
  }

  void dispose() {
    socket.disconnect();
    socket.close();
  }
}
