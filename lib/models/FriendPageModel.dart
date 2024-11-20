class FriendPageModel {
  int? status;
  String? message;
  List<Users>? users;

  FriendPageModel({this.status, this.message, this.users});

  FriendPageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Users(
      {this.sId,
      this.name,
      this.email,
      this.password,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
