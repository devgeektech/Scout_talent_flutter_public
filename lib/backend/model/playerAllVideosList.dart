class PlayerAllVideosRes {
  int? responseCode;
  String? responseMessage;
  List<PlayerAllVideosData>? data;
  int? totalRecord;

  PlayerAllVideosRes(
      {this.responseCode, this.responseMessage, this.data, this.totalRecord});

  PlayerAllVideosRes.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['data'] != null) {
      data = <PlayerAllVideosData>[];
      json['data'].forEach((v) {
        data!.add(new PlayerAllVideosData.fromJson(v));
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

class PlayerAllVideosData {
  String? sId;
  String? title;
  String? thumbnail;
  String? video;
  String? description;
  String? player;
  String? createdBy;
  // List<Null>? likes;
  // List<Null>? shares;
  // List<Null>? comments;
  String? privacy;
  bool? isVerified;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PlayerAllVideosData(
      {this.sId,
        this.title,
        this.thumbnail,
        this.video,
        this.description,
        this.player,
        this.createdBy,
        // this.likes,
        // this.shares,
        // this.comments,
        this.privacy,
        this.isVerified,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PlayerAllVideosData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    description = json['description'];
    player = json['player'];
    createdBy = json['createdBy'];
    // if (json['likes'] != null) {
    //   likes = <Null>[];
    //   json['likes'].forEach((v) {
    //     likes!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['shares'] != null) {
    //   shares = <Null>[];
    //   json['shares'].forEach((v) {
    //     shares!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['comments'] != null) {
    //   comments = <Null>[];
    //   json['comments'].forEach((v) {
    //     comments!.add(new Null.fromJson(v));
    //   });
    // }
    privacy = json['privacy'];
    isVerified = json['isVerified'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['video'] = this.video;
    data['description'] = this.description;
    data['player'] = this.player;
    data['createdBy'] = this.createdBy;
    // if (this.likes != null) {
    //   data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    // }
    // if (this.shares != null) {
    //   data['shares'] = this.shares!.map((v) => v.toJson()).toList();
    // }
    // if (this.comments != null) {
    //   data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    // }
    data['privacy'] = this.privacy;
    data['isVerified'] = this.isVerified;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
