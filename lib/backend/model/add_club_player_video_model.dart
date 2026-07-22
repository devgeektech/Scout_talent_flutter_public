class AddClubPlayerVideoModel {
  AddClubPlayerVideoModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory AddClubPlayerVideoModel.fromJson(Map<String, dynamic> json){
    return AddClubPlayerVideoModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.trialId,
    required this.playerId,
    required this.drillOneVideo,
    required this.drillTwoVideo,
    required this.drillThreeVideo,
    required this.drillFourVideo,
    required this.createdBy,
    required this.isDeleted,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? trialId;
  final String? playerId;
  final String? drillOneVideo;
  final String? drillTwoVideo;
  final String? drillThreeVideo;
  final String? drillFourVideo;
  final String? createdBy;
  final bool? isDeleted;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      trialId: json["trialId"],
      playerId: json["playerId"],
      drillOneVideo: json["drillOneVideo"],
      drillTwoVideo: json["drillTwoVideo"],
      drillThreeVideo: json["drillThreeVideo"],
      drillFourVideo: json["drillFourVideo"],
      createdBy: json["createdBy"],
      isDeleted: json["isDeleted"],
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
