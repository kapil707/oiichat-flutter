class HomePageModel {
  String? success;
  String? message;
  String? title;
  String? categoryId;
  String? pageType;
  int? nextId;
  List<Items>? items;

  HomePageModel(
      {this.success,
      this.message,
      this.title,
      this.categoryId,
      this.pageType,
      this.nextId,
      this.items});

  HomePageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    title = json['title'];
    categoryId = json['category_id'];
    pageType = json['page_type'];
    nextId = json['next_id'];
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
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['page_type'] = this.pageType;
    data['next_id'] = this.nextId;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? itemId;
  String? itemTitle;
  String? itemType;
  String? itemCode;
  String? itemDivision;
  String? itemImage;
  String? itemWebAction;
  String? itemPageType;

  Items(
      {this.itemId,
      this.itemTitle,
      this.itemType,
      this.itemCode,
      this.itemDivision,
      this.itemImage,
      this.itemWebAction,
      this.itemPageType});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemTitle = json['item_title'];
    itemType = json['item_type'];
    itemCode = json['item_code'];
    itemDivision = json['item_division'];
    itemImage = json['item_image'];
    itemWebAction = json['item_web_action'];
    itemPageType = json['item_page_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item_title'] = this.itemTitle;
    data['item_type'] = this.itemType;
    data['item_code'] = this.itemCode;
    data['item_division'] = this.itemDivision;
    data['item_image'] = this.itemImage;
    data['item_web_action'] = this.itemWebAction;
    data['item_page_type'] = this.itemPageType;
    return data;
  }
}