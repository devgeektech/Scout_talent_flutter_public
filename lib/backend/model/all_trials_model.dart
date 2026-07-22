class AllTrialsModel {
  AllTrialsModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final List<AllTrialList>? data;

  factory AllTrialsModel.fromJson(Map<String, dynamic> json){
    return AllTrialsModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<AllTrialList>.from(json["data"]!.map((x) => AllTrialList.fromJson(x))),
    );
  }

}

class AllTrialList {
  AllTrialList({
    required this.id,
    required this.name,
    required this.category,
    required this.roCategory,
    required this.thumbnail,
    required this.video,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.drillOne,
    required this.drillTwo,
    required this.drillThree,
    required this.drillFour,
    required this.createdAt,
    required this.updatedAt,
    required this.createdByUser,
  });

  final String? id;
  final String? name;
  final String? category;
  final String? roCategory;
  final String? thumbnail;
  final String? video;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? drillOne;
  final String? drillTwo;
  final String? drillThree;
  final String? drillFour;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CreatedByUser? createdByUser;

  factory AllTrialList.fromJson(Map<String, dynamic> json){
    return AllTrialList(
      id: json["_id"],
      name: json["name"],
      category: json["category"],
      roCategory: json["roCategory"],
      thumbnail: json["thumbnail"],
      video: json["video"],
      description: json["description"],
      startDate: DateTime.tryParse(json["startDate"] ?? ""),
      endDate: DateTime.tryParse(json["endDate"] ?? ""),
      drillOne: json["drillOne"],
      drillTwo: json["drillTwo"],
      drillThree: json["drillThree"],
      drillFour: json["drillFour"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      createdByUser: json["createdByUser"] == null ? null : CreatedByUser.fromJson(json["createdByUser"]),
    );
  }

}

class CreatedByUser {
  CreatedByUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.avatar,
    required this.club,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? avatar;
  final String? club;

  factory CreatedByUser.fromJson(Map<String, dynamic> json){
    return CreatedByUser(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      avatar: json["avatar"],
      club: json["club"],
    );
  }

}
