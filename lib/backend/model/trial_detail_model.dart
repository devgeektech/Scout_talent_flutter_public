class TrialsDetailModel {
  TrialsDetailModel({
     this.code,
     this.message,
     this.data,
  });

  final num? code;
  final String? message;
  final Data? data;

  factory TrialsDetailModel.fromJson(Map<String, dynamic> json){
    return TrialsDetailModel(
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
    required this.createdAt,
    required this.updatedAt,
    required this.v,
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

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
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}
