class ChatModel {
  String user_id;
  String name;
  String image;
  String message;
  String time;

  ChatModel({
    required this.user_id,
    required this.name,
    required this.image,
    required this.message,
    required this.time,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'name': name,
      'image': image,
      'message': message,
      'time': time,
    };
  }

  // Create a Message object from a Map
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      user_id: map['user_id'],
      name: map['name'],
      image: map['image'],
      message: map['message'],
      time: map['time'],
    );
  }
}
