class LoginModel {
  int? status;
  String? message;
  Users? users;

  LoginModel({this.status, this.message, this.users});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? userEmail;
  String? userName;

  Users({this.userId, this.userEmail, this.userName});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    return data;
  }
}
