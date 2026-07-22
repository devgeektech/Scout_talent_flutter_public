class PlayerActivityResponse {
  int? responseCode;
  String? responseMessage;
  List<PlayerActivitiesData>? data;
  int? totalRecord;

  PlayerActivityResponse(
      {this.responseCode, this.responseMessage, this.data, this.totalRecord});

  PlayerActivityResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['data'] != null) {
      data = <PlayerActivitiesData>[];
      json['data'].forEach((v) {
        data!.add(new PlayerActivitiesData.fromJson(v));
      });
    }
    totalRecord = json['totalRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalRecord'] = this.totalRecord;
    return data;
  }
}

class PlayerActivitiesData {
  String? sId;
  String? type;
  Title? title;
  DateTime? createdAt;
  String? updatedAt;
  String? userId;
  String? role;
  String? name;
  String? avatar;

  PlayerActivitiesData(
      {this.sId,
        this.type,
        this.title,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.role,
        this.name,
        this.avatar});

  PlayerActivitiesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    role = json['role'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
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
