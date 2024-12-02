class FriendPageModelApi {
  int? status;
  String? message;
  Users? users;

  FriendPageModelApi({this.status, this.message, this.users});

  FriendPageModelApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (users != null) {
      data['users'] = users!.toJson();
    }
    return data;
  }
}

class Users {
  String? sId;
  String? name;
  String? userImage;

  Users({this.sId, this.name, this.userImage});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['user_image'] = this.userImage;
    return data;
  }
}
