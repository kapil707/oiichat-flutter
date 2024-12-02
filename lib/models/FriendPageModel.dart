class FriendPageModel {
  String sId;
  String name;
  String user_image;

  FriendPageModel({
    required this.sId,
    required this.name,
    required this.user_image,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      '_id': sId,
      'name': name,
      'user_image': user_image,
    };
  }

  // Create a Message object from a Map
  factory FriendPageModel.fromMap(Map<String, dynamic> map) {
    return FriendPageModel(
      sId: map['_id'],
      name: map['name'],
      user_image: map['user_image'],
    );
  }
}
