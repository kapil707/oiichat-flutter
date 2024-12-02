class FriendPageModel {
  String user_id;
  String name;
  String image;

  FriendPageModel({
    required this.user_id,
    required this.name,
    required this.image,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'name': name,
      'image': image,
    };
  }

  // Create a Message object from a Map
  factory FriendPageModel.fromMap(Map<String, dynamic> map) {
    return FriendPageModel(
      user_id: map['user_id'],
      name: map['name'],
      image: map['image'],
    );
  }
}
