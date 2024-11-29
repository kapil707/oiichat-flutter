class ChatRoomModel {
  String user_id;
  String message;
  String time;

  ChatRoomModel({
    required this.user_id,
    required this.message,
    required this.time,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'message': message,
      'time': time,
    };
  }

  // Create a Message object from a Map
  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      user_id: map['user_id'],
      message: map['message'],
      time: map['time'],
    );
  }
}
