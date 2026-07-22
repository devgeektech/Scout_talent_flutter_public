class UploadTrialModel {
  UploadTrialModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory UploadTrialModel.fromJson(Map<String, dynamic> json){
    return UploadTrialModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.name,
    required this.video,
    required this.category,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.drillOne,
    required this.drillTwo,
    required this.drillThree,
    required this.drillFour,
    required this.createdBy,
    required this.isDeleted,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? name;
  final String? video;
  final String? category;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? drillOne;
  final String? drillTwo;
  final String? drillThree;
  final String? drillFour;
  final String? createdBy;
  final bool? isDeleted;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      name: json["name"],
      video: json["video"],
      category: json["category"],
      description: json["description"],
      startDate: DateTime.tryParse(json["startDate"] ?? ""),
      endDate: DateTime.tryParse(json["endDate"] ?? ""),
      drillOne: json["drillOne"],
      drillTwo: json["drillTwo"],
      drillThree: json["drillThree"],
      drillFour: json["drillFour"],
      createdBy: json["createdBy"],
      isDeleted: json["isDeleted"],
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
