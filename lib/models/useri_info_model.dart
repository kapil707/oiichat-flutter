class UseriInfoModel {
  final int? id; // Primary key
  final String user_id;
  final String user_name;

  UseriInfoModel({
    this.id,
    required this.user_id,
    required this.user_name,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'user_name': user_name,
    };
  }

  // Create a Message object from a Map
  factory UseriInfoModel.fromMap(Map<String, dynamic> map) {
    return UseriInfoModel(
      id: map['id'],
      user_id: map['user_id'],
      user_name: map['user_name'],
    );
  }
}
