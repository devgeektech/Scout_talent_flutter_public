class UploadedTrialsListResponse {
  int? responseCode;
  String? responseMessage;
  List<Data>? data;
  int? totalRecord;

  UploadedTrialsListResponse(
      {this.responseCode, this.responseMessage, this.data, this.totalRecord});

  UploadedTrialsListResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    totalRecord = json['totalRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalRecord'] = totalRecord;
    return data;
  }
}

class Data {
  String? sId;
  String? trialId;
  String? playerId;
  String? drillOneVideo;
  String? drillTwoVideo;
  String? drillThreeVideo;
  String? drillFourVideo;
  String? createdAt;
  String? updatedAt;
  Player? player;
  bool? myPlayer;

  Data(
      {this.sId,
        this.trialId,
        this.playerId,
        this.drillOneVideo,
        this.drillTwoVideo,
        this.drillThreeVideo,
        this.drillFourVideo,
        this.createdAt,
        this.updatedAt,
        this.player,
        this.myPlayer,
      });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    trialId = json['trialId'];
    playerId = json['playerId'];
    drillOneVideo = json['drillOneVideo'];
    drillTwoVideo = json['drillTwoVideo'];
    drillThreeVideo = json['drillThreeVideo'];
    drillFourVideo = json['drillFourVideo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    myPlayer = json['myPlayer'];
    player =
    json['player'] != null ? Player.fromJson(json['player']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['trialId'] = trialId;
    data['playerId'] = playerId;
    data['drillOneVideo'] = drillOneVideo;
    data['drillTwoVideo'] = drillTwoVideo;
    data['drillThreeVideo'] = drillThreeVideo;
    data['drillFourVideo'] = drillFourVideo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['myPlayer'] = myPlayer;
    if (player != null) {
      data['player'] = player!.toJson();
    }
    return data;
  }
}

class Player {
  String? sId;
  String? firstName;
  String? lastName;
  String? role;
  String? email;
  String? avatar;

  Player(
      {this.sId,
        this.firstName,
        this.lastName,
        this.role,
        this.email,
        this.avatar});

  Player.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['role'] = role;
    data['email'] = email;
    data['avatar'] = avatar;
    return data;
  }
}
