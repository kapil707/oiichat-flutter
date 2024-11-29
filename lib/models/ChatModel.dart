class ChatModel {
  String user_id;
  String user_id2;
  String name;
  String image;
  String message;
  String time;
  int status;

  ChatModel({
    required this.user_id,
    required this.user_id2,
    required this.name,
    required this.image,
    required this.message,
    required this.time,
    required this.status,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'user_id2': user_id2,
      'name': name,
      'image': image,
      'message': message,
      'time': time,
      'status': status,
    };
  }

  // Create a Message object from a Map
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      user_id: map['user_id'],
      user_id2: map['user_id2'],
      name: map['name'],
      image: map['image'],
      message: map['message'],
      time: map['time'],
      status: map['status'],
    );
  }
}
