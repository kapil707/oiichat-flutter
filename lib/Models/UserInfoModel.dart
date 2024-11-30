class UserInfoModel {
  final int? id; // Primary key
  final String user_id;
  final String user_name;
  final String user_image;

  UserInfoModel({
    this.id,
    required this.user_id,
    required this.user_name,
    required this.user_image,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'user_name': user_name,
      'user_image': user_image,
    };
  }

  // Create a Message object from a Map
  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      id: map['id'],
      user_id: map['user_id'],
      user_name: map['user_name'],
      user_image: map['user_image'],
    );
  }
}
