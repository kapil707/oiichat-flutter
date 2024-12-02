class FriendPageModel {
  final String name;
  final String userImage;
  final String id;

  FriendPageModel({
    required this.name,
    required this.userImage,
    required this.id,
  });

  factory FriendPageModel.fromJson(Map<String, dynamic> json) {
    return FriendPageModel(
      name: json['name'] ?? '',
      userImage: json['user_image'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user_image': userImage,
      'id': id,
    };
  }
}
