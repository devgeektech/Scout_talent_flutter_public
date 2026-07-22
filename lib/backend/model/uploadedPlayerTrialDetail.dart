class UploadedPlayerTrialDetail {
  int? responseCode;
  String? responseMessage;
  Data? data;

  UploadedPlayerTrialDetail(
      {this.responseCode, this.responseMessage, this.data});

  UploadedPlayerTrialDetail.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? description;
  Player? player;
  String? status;

  List<Drills>? drills;

  Data({this.sId, this.name, this.description, this.player, this.drills,this.status});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    player =
    json['player'] != null ? Player.fromJson(json['player']) : null;
    if (json['drills'] != null) {
      drills = <Drills>[];
      json['drills'].forEach((v) {
        drills!.add(Drills.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    if (player != null) {
      data['player'] = player!.toJson();
    }
    if (drills != null) {
      data['drills'] = drills!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Player {
  String? firstName;
  String? lastName;
  String? avatar;

  Player({this.firstName, this.lastName, this.avatar});

  Player.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['avatar'] = avatar;
    return data;
  }
}

class Drills {
  int? srNo;
  String? title;
  String? description;
  String? thumbnail;
  String? video;

  Drills({this.srNo, this.title, this.description, this.video});

  Drills.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    title = json['title'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['srNo'] = srNo;
    data['title'] = title;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    data['video'] = video;
    return data;
  }
}
