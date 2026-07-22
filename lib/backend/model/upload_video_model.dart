class UploadVideoModel {
  UploadVideoModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory UploadVideoModel.fromJson(Map<String, dynamic> json){
    return UploadVideoModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
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
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? title;
  final String? video;
  final String? description;
  final String? player;
  final String? createdBy;
  final List<dynamic> likes;
  final List<dynamic> shares;
  final List<dynamic> comments;
  final String? privacy;
  final bool? isVerified;
  final bool? isDeleted;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      title: json["title"],
      video: json["video"],
      description: json["description"],
      player: json["player"],
      createdBy: json["createdBy"],
      likes: json["likes"] == null ? [] : List<dynamic>.from(json["likes"]!.map((x) => x)),
      shares: json["shares"] == null ? [] : List<dynamic>.from(json["shares"]!.map((x) => x)),
      comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
      privacy: json["privacy"],
      isVerified: json["isVerified"],
      isDeleted: json["isDeleted"],
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
