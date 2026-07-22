class AddPlayerVideoModel {
  AddPlayerVideoModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory AddPlayerVideoModel.fromJson(Map<String, dynamic> json){
    return AddPlayerVideoModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
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
