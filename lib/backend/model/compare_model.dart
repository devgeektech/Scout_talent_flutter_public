class CompareModel {
  CompareModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<CompareBody>? data;
  final int? totalRecord;

  factory CompareModel.fromJson(Map<String, dynamic> json){
    return CompareModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<CompareBody>.from(json["data"]!.map((x) => CompareBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class CompareBody {
  CompareBody({
    required this.id,
    required this.playerId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
    required this.role,
    required this.position,
    required this.roPosition,
  });

  final String? id;
  final String? playerId;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final String? role;
  final String? position;
  final String? roPosition;

  bool isSelectSave = false;
  bool isAddToCard = false;
  bool isSelectRate = false;


  factory CompareBody.fromJson(Map<String, dynamic> json){
    return CompareBody(
      id: json["_id"],
      playerId: json["playerId"],
      createdBy: json["createdBy"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      avatar: json["avatar"],
      role: json["role"],
      position: json["position"],
      roPosition: json["roPosition"],
    );
  }


  Map<String, dynamic> toJson() => {
    "_id": id,
    "playerId": playerId,
    "createdBy": createdBy,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "firstName": firstName,
    "lastName": lastName,
    "role": role,
    "email": email,
    "avatar": avatar,
  };

}
