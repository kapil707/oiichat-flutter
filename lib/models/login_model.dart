class LoginModel {
  String? success;
  String? message;
  List<Items>? items;

  LoginModel({this.success, this.message, this.items});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? userSession;
  String? userFname;
  String? userCode;
  String? userAltercode;
  String? userType;
  String? userPassword;
  String? userImage;
  String? userNrx;
  String? status;
  String? statusMessage;

  Items(
      {this.userSession,
      this.userFname,
      this.userCode,
      this.userAltercode,
      this.userType,
      this.userPassword,
      this.userImage,
      this.userNrx,
      this.status,
      this.statusMessage});

  Items.fromJson(Map<String, dynamic> json) {
    userSession = json['user_session'];
    userFname = json['user_fname'];
    userCode = json['user_code'];
    userAltercode = json['user_altercode'];
    userType = json['user_type'];
    userPassword = json['user_password'];
    userImage = json['user_image'];
    userNrx = json['user_nrx'];
    status = json['status'];
    statusMessage = json['status_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_session'] = this.userSession;
    data['user_fname'] = this.userFname;
    data['user_code'] = this.userCode;
    data['user_altercode'] = this.userAltercode;
    data['user_type'] = this.userType;
    data['user_password'] = this.userPassword;
    data['user_image'] = this.userImage;
    data['user_nrx'] = this.userNrx;
    data['status'] = this.status;
    data['status_message'] = this.statusMessage;
    return data;
  }
}