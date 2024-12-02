import 'package:oiichat/Models/UserInfoModel.dart';
import 'package:oiichat/config/main_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:math';

import '../Config/database_helper.dart';
import '../Models/message.dart';

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
  Function(dynamic)? onUserInfoReceived;
  Function(dynamic)? onUserTypingReceived;

  void initSocket(String user) {
    // Socket.IO connection setup
    socket = IO.io(MainConfig.host_url, <String, dynamic>{
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
      //print("user ka naam " + data["user_image"]);
      //user ki info insert or update hotai ha yaha say
      final newUser = UserInfoModel(
        user_id: data["user1"],
        user_name: data["user_name"],
        user_image: data["user_image"],
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

    socket.on("get_user_info_response", (data) {
      print("User status: ${data['user_id']}");
      if (onUserInfoReceived != null) {
        onUserInfoReceived!(data);
      }
    });

    socket.on('receiveTyping', (data) async {
      //print("receiveTyping" + data["status"]);
      if (onUserTypingReceived != null) {
        onUserTypingReceived!(data);
      }
    });

    socket.on('get_old_message_response', (data) async {
      final List<dynamic> messages = data["messages"];
      for (var message in messages) {
        print("message " + message["user1_info"]["name"]);
        final newMessage = Message(
          user1: message["user1"],
          user2: message["user2"],
          message: message["message"],
          status: 1,
          timestamp: DateTime.now().toIso8601String(),
        );
        await dbHelper.insertMessage(newMessage);

        final newUser = UserInfoModel(
          user_id: message["user1"],
          user_name: message["user1_info"]["name"],
          user_image: message["user1_info"]["user_image"],
        );
        await dbHelper.insertOrUpdateUserInfo(newUser);
      }
    });
  }

  void GetUserInfo(String userId) {
    socket.emit("get_user_info", userId);
  }

  void GetOldMessage(String userId) {
    print("call get_old_message");
    socket.emit("get_old_message", userId);
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
      print("msg ${messages.id}");
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

  void userTyping(String user1, String user2, String status) async {
    socket.emit('userTyping', {
      'user1': user1,
      'user2': user2,
      'status': status,
    });
  }

  void dispose() {
    socket.disconnect();
    socket.close();
  }
}
