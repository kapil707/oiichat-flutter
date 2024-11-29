class ChatRoomModel {
  String user_id;
  String message;
  String time;
  int status;

  ChatRoomModel({
    required this.user_id,
    required this.message,
    required this.time,
    required this.status,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'message': message,
      'time': time,
      'status': status,
    };
  }

  // Create a Message object from a Map
  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      user_id: map['user_id'],
      message: map['message'],
      time: map['time'],
      status: map['status'],
    );
  }
}
