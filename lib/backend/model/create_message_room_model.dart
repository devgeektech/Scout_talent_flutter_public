class CreateMessageRoomModel {
  CreateMessageRoomModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory CreateMessageRoomModel.fromJson(Map<String, dynamic> json){
    return CreateMessageRoomModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.users,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final List<CreatedBy> users;
  final CreatedBy? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      users: json["users"] == null ? [] : List<CreatedBy>.from(json["users"]!.map((x) => CreatedBy.fromJson(x))),
      createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
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
    required this.role,
    required this.avatar,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? avatar;

  factory CreatedBy.fromJson(Map<String, dynamic> json){
    return CreatedBy(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      avatar: json["avatar"],
    );
  }

}
