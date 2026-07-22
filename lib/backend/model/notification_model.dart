class NotificationResModel {
  int? responseCode;
  String? responseMessage;
  Data? data;
  int? totalRecord;

  NotificationResModel(
      {this.responseCode, this.responseMessage, this.data, this.totalRecord});

  NotificationResModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    totalRecord = json['totalRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['totalRecord'] = this.totalRecord;
    return data;
  }
}

class Data {
  int? unreadCount;
  List<NotificationList>? notificationList;

  Data({this.unreadCount, this.notificationList});

  Data.fromJson(Map<String, dynamic> json) {
    unreadCount = json['unreadCount'];
    if (json['list'] != null) {
      notificationList = <NotificationList>[];
      json['list'].forEach((v) {
        notificationList!.add(new NotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unreadCount'] = this.unreadCount;
    if (this.notificationList != null) {
      data['list'] = this.notificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationList {
  String? sId;
  String? receiver;
  String? sender;
  String? type;
  Title? title;
  Title? description;
  String? date;
  bool? isRead;
  bool? isDeleted;
  int? iV;
  DateTime? createdAt;
  String? updatedAt;

  NotificationList(
      {this.sId,
        this.receiver,
        this.sender,
        this.type,
        this.title,
        this.description,
        this.date,
        this.isRead,
        this.isDeleted,
        this.iV,
        this.createdAt,
        this.updatedAt});

  NotificationList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    receiver = json['receiver'];
    sender = json['sender'];
    type = json['type'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    description = json['description'] != null
        ? new Title.fromJson(json['description'])
        : null;
    date = json['date'];
    isRead = json['isRead'];
    isDeleted = json['isDeleted'];
    iV = json['__v'];
    createdAt = DateTime.tryParse(json["createdAt"] ?? "");
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['receiver'] = this.receiver;
    data['sender'] = this.sender;
    data['type'] = this.type;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['date'] = this.date;
    data['isRead'] = this.isRead;
    data['isDeleted'] = this.isDeleted;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
class Title {
  String? en;
  String? ro;

  Title({this.en, this.ro});

  Title.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ro = json['ro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ro'] = this.ro;
    return data;
  }
}