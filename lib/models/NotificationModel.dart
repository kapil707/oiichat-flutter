class NotificationModel {
  String? success;
  String? message;
  List<Items>? items;
  int? getRecord;

  NotificationModel({this.success, this.message, this.items, this.getRecord});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    getRecord = json['get_record'];
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
    data['get_record'] = this.getRecord;
    return data;
  }
}

class Items {
  String? itemId;
  String? itemTitle;
  String? itemMessage;
  String? itemDateTime;
  String? itemImage;

  Items(
      {this.itemId,
      this.itemTitle,
      this.itemMessage,
      this.itemDateTime,
      this.itemImage});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemTitle = json['item_title'];
    itemMessage = json['item_message'];
    itemDateTime = json['item_date_time'];
    itemImage = json['item_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item_title'] = this.itemTitle;
    data['item_message'] = this.itemMessage;
    data['item_date_time'] = this.itemDateTime;
    data['item_image'] = this.itemImage;
    return data;
  }
}