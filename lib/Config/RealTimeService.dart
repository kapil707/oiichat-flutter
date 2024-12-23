import 'package:oiichat/Config/notification.dart';
import 'package:oiichat/models/UserInfoModel.dart';
import 'package:oiichat/config/main_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:math';

import '../config/database_helper.dart';
import '../models/message.dart';

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
  Function(String)? onMessageReceivedNew;
  Function(dynamic)? onUserInfoReceived;
  Function(dynamic)? onUserTypingReceived;

  Function(dynamic)? onIncomingCall;
  Function(dynamic)? onIncomingCallCancel;

  Function(dynamic)? onAcceptCallByUser;
  Function(dynamic)? onRejectCallByUser;

  Function(dynamic)? onCutCallByUser;

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

    socket.on('receiveMessage', (message) async {
      //print("user ka naam " + data["user_image"]);

      //insert new chat
      final newMessage = Message(
        user1: message["user1"],
        user2: message["user2"],
        message: message["message"],
        status: 1,
        timestamp: DateTime.now().toIso8601String(),
      );
      await dbHelper.insertMessage(newMessage);

      //insert update user info
      final newUser = UserInfoModel(
        user_id: message["user1"],
        user_name: message["user_name"],
        user_image: message["user_image"],
      );
      await dbHelper.insertOrUpdateUserInfo(newUser);

      if (onMessageReceived != null) {
        onMessageReceived!(message["message"]);
      }
    });

    socket.on('messageSent', (message) async {
      //update message status send or not
      if (message['status'] == 'success') {
        var id = message['messageId'];
        await dbHelper.updateMessageStatus(id, 1);
        onMessageSend!("1");
      }
    });

    socket.on("get_user_info_response", (data) async {
      print("User status: ${data['user_id']}");
      // print("User status: ${data['user_name']}");
      // print("User status: ${data['user_image']}");

      if (data["user_image"] != null) {
        //insert update user info
        final newUser = UserInfoModel(
          user_id: data["user_id"],
          user_name: data["user_name"],
          user_image: data["user_image"],
        );
        await dbHelper.insertOrUpdateUserInfo(newUser);
      } else {
        if (data["user_image"] != null) {
          //insert update user info
          final newUser = UserInfoModel(
            user_id: data["user_id"],
            user_name: data["user_name"],
            user_image: "",
          );
          await dbHelper.insertOrUpdateUserInfo(newUser);
        }
      }
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
      print("get_old_message_response ${messages.length}");
      for (var message in messages) {
        print("get_old_message_response " + message["user_name"]);
        //insert new chat
        final newMessage = Message(
          user1: message["user1"],
          user2: message["user2"],
          message: message["message"],
          status: 1,
          timestamp: DateTime.now().toIso8601String(),
        );
        await dbHelper.insertMessage(newMessage);

        //insert update user info
        final newUser = UserInfoModel(
          user_id: message["user1"],
          user_name: message["user_name"],
          user_image: message["user_image"],
        );
        await dbHelper.insertOrUpdateUserInfo(newUser);

        onMessageReceivedNew!("1");
      }
    });

    //call handle
    //jab kisi dusray user nay call ki ha to wo iss say open hoti ha iss say call ring karti ha
    socket.on('incoming-call', (data) {
      print('oiicall incoming-call ' + data['user1']);
      NotificationService.showCallNotification('John Doe', 'Audio Call');
      //onIncomingCall!(data);
      if (onIncomingCall != null) {
        onIncomingCall!(data);
      }
    });

    //jab kisi dusray user nay call ki ha or agar wo he call cut karta ha ringing time me to
    socket.on('incoming-call-cancel', (data) {
      print('oiicall incoming-call-cancel ' + data['user1']);
      //onIncomingCallCancel!(data);
      if (onIncomingCallCancel != null) {
        onIncomingCallCancel!(data);
      }
    });

    //jiss ke pass call ayi ha agar wo call cut karta ha to
    socket.on('reject-call-by-user', (data) async {
      print('oiicall reject-call-by-user');
      if (onRejectCallByUser != null) {
        onRejectCallByUser!(data);
      }
    });

    socket.on('accept-call-by-user', (data) async {
      //print('oiicall accept-call-by-user ' + data['user1']);
      if (onAcceptCallByUser != null) {
        onAcceptCallByUser!(data);
      }
    });

    socket.on('cut-call-by-user', (data) async {
      //print('oiicall accept-call-by-user ' + data['user1']);
      if (onCutCallByUser != null) {
        onCutCallByUser!(data);
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

  //call ke liya
  //jab user1 user2 ko call karta ha
  void request_call(user1, user2) {
    socket.emit('request-call', {
      'user1': user1, // Caller (User A)
      'user2': user2, // Recipient (User B username)
    });
    print('oiicall request_call');
  }

  //jiss user nay call ki ha agar wo he call cut karta ha to
  void request_call_cancel(user1, user2) {
    socket.emit('request-call-cancel', {
      'user1': user1, // Caller (User A)
      'user2': user2, // Recipient (User B username)
    });
    print('oiicall request_call_cancel');
  }

  //jiss ke pass call ayi ha agar wo call cut karta ha to
  void request_call_reject(user1, user2) {
    socket.emit('request-call-reject', {
      'user1': user2, // Caller (User A)
      'user2': user1, // Recipient (User B username)
    });
    print('oiicall request_call_reject');
  }

  void request_call_accept(user1, user2) {
    socket.emit('request-call-accept', {
      'user1': user2, // Caller (User A)
      'user2': user1, // Recipient (User B username)
    });
    print('oiicall request_call_accept');
  }

  void request_call_cut(user1, user2) {
    socket.emit('request-call-cut', {
      'user1': user2, // Caller (User A)
      'user2': user1, // Recipient (User B username)
    });
    print('oiicall request_call_cut');
  }

  void dispose() {
    socket.disconnect();
    socket.close();
  }
}
