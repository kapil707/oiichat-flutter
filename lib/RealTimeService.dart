import 'package:socket_io_client/socket_io_client.dart' as IO;

class RealTimeService {
  late IO.Socket socket;
  Function(String, String,String)? onLoginResponse;
  Function(List<Map<String, dynamic>>)? onAllUsersReceived;
  Function(List<Map<String, dynamic>>)? receiveMessage;

  void initSocket() {
    // Socket.IO connection setup
    socket = IO.io('http://192.168.1.7:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Listen for server events
    socket.on('connect', (_) {
      print('Connected to the server');
    });

    socket.on('server_update', (data) {
      print('Real-time data from server: ${data['message']}');
    });

    // Send data to server
    socket.emit('client_update', {'message': 'Hello from Flutter'});

    // Handle disconnection
    socket.on('disconnect', (_) => print('Disconnected from server'));

    // Listen for login response and notify listener
    socket.on('login_response', (data) {
      if (onLoginResponse != null) {
        onLoginResponse!(data['message'], data['userId'] ?? "", data['userName'] ?? ""); // Passing userId here
      }
    });

    // Listen for all users response and notify listener
    socket.on('all_users', (data) {
      if (onAllUsersReceived != null) {
        onAllUsersReceived!(List<Map<String, dynamic>>.from(data));
      }
    });

    socket.emit('joinRoom','6735b919c9b5f0da9da5fb9a');
    // Receive real-time messages
    socket.on('receiveMessage', (data) {
      print("working receiveMessage");
    });
    
  }

   void addUser(String name, String email, String password) {
    socket.emit('add_user', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  void loginUser(String email, String password) {
    print(email);
    socket.emit('login_user', {
      'email': email,
      'password': password,
    });
  }
  

  void getAllUsers() {
    socket.emit('get_all_users'); // Request for all users
  }

  /******************************** */

  void joinRoom(String roomId) {    
    socket.emit('joinRoom', {'roomId': roomId});
  }

  void sendMessage(String user1,String user2,String message) { 
    socket.emit('sendMessage', {
          'user1': user1,
          'user2': user2,
          'message': message,
        });
  }

  void dispose() {
    socket.disconnect();
  }
}
