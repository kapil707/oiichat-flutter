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
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['get_record'] = getRecord;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_title'] = itemTitle;
    data['item_message'] = itemMessage;
    data['item_date_time'] = itemDateTime;
    data['item_image'] = itemImage;
    return data;
  }
}
