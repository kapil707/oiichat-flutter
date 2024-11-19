class Message {
  final int? id; // Primary key
  final String user1;
  final String user2;
  final String message;
  final String timestamp;

  Message({
    this.id,
    required this.user1,
    required this.user2,
    required this.message,
    required this.timestamp,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1': user1,
      'user2': user2,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // Create a Message object from a Map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      user1: map['user1'],
      user2: map['user2'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
