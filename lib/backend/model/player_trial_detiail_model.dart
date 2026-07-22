class PlayerTrialDetail {
  PlayerTrialDetail({
     this.code,
     this.message,
     this.data,
  });

  final num? code;
  final String? message;
  final Data? data;

  factory PlayerTrialDetail.fromJson(Map<String, dynamic> json){
    return PlayerTrialDetail(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.video,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.drillOne,
    required this.drillTwo,
    required this.drillThree,
    required this.drillFour,
    required this.createdBy,
    required this.isDeleted,
    required this.playerTrialVideo,
  });

  final String? id;
  final String? name;
  final String? thumbnail;
  final String? video;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? drillOne;
  final String? drillTwo;
  final String? drillThree;
  final String? drillFour;
  final String? createdBy;
  final bool? isDeleted;
  final PlayerTrialVideo? playerTrialVideo;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      name: json["name"],
      thumbnail: json["thumbnail"],
      video: json["video"],
      description: json["description"],
      startDate: DateTime.tryParse(json["startDate"] ?? ""),
      endDate: DateTime.tryParse(json["endDate"] ?? ""),
      drillOne: json["drillOne"],
      drillTwo: json["drillTwo"],
      drillThree: json["drillThree"],
      drillFour: json["drillFour"],
      createdBy: json["createdBy"],
      isDeleted: json["isDeleted"],
      playerTrialVideo: json["playerTrialVideo"] == null ? null : PlayerTrialVideo.fromJson(json["playerTrialVideo"]),
    );
  }

}

class PlayerTrialVideo {
  PlayerTrialVideo({
    required this.id,
    required this.trialId,
    required this.playerId,
    required this.drillOneVideo,
    required this.drillTwoVideo,
    required this.drillThreeVideo,
    required this.drillFourVideo,
    required this.status,
    required this.createdBy,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? trialId;
  final String? playerId;
  final String? drillOneVideo;
  final String? drillTwoVideo;
  final String? drillThreeVideo;
  final String? drillFourVideo;
  final String? status;
  final String? createdBy;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PlayerTrialVideo.fromJson(Map<String, dynamic> json){
    return PlayerTrialVideo(
      id: json["_id"],
      trialId: json["trialId"],
      playerId: json["playerId"],
      drillOneVideo: json["drillOneVideo"],
      drillTwoVideo: json["drillTwoVideo"],
      drillThreeVideo: json["drillThreeVideo"],
      drillFourVideo: json["drillFourVideo"],
      status: json["status"],
      createdBy: json["createdBy"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
