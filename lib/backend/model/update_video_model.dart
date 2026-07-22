class UpdateVideoModel {
  UpdateVideoModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory UpdateVideoModel.fromJson(Map<String, dynamic> json){
    return UpdateVideoModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.title,
    required this.video,
    required this.description,
    required this.player,
    required this.createdBy,
    required this.likes,
    required this.shares,
    required this.comments,
    required this.privacy,
    required this.isVerified,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? title;
  final String? video;
  final String? description;
  final String? player;
  final CreatedBy? createdBy;
  final List<dynamic> likes;
  final List<dynamic> shares;
  final List<dynamic> comments;
  final String? privacy;
  final bool? isVerified;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      title: json["title"],
      video: json["video"],
      description: json["description"],
      player: json["player"],
      createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
      likes: json["likes"] == null ? [] : List<dynamic>.from(json["likes"]!.map((x) => x)),
      shares: json["shares"] == null ? [] : List<dynamic>.from(json["shares"]!.map((x) => x)),
      comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
      privacy: json["privacy"],
      isVerified: json["isVerified"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class CreatedBy {
  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  factory CreatedBy.fromJson(Map<String, dynamic> json){
    return CreatedBy(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
    );
  }

}
