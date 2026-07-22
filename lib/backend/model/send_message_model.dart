class SendMessageModel {
  SendMessageModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory SendMessageModel.fromJson(Map<String, dynamic> json){
    return SendMessageModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.message,
    required this.sender,
    required this.isSeen,
    required this.receiver,
    required this.createdAt,
    required this.senderDetail,
    required this.receiverDetail,
  });

  final String? id;
  final String? message;
  final String? sender;
  final bool? isSeen;
  final String? receiver;
  final DateTime? createdAt;
  final ErDetail? senderDetail;
  final ErDetail? receiverDetail;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      message: json["message"],
      sender: json["sender"],
      isSeen: json["isSeen"],
      receiver: json["receiver"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      senderDetail: json["senderDetail"] == null ? null : ErDetail.fromJson(json["senderDetail"]),
      receiverDetail: json["receiverDetail"] == null ? null : ErDetail.fromJson(json["receiverDetail"]),
    );
  }

}

class ErDetail {
  ErDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.avatar,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? avatar;

  factory ErDetail.fromJson(Map<String, dynamic> json){
    return ErDetail(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      avatar: json["avatar"],
    );
  }

}
extension DataToJson on Data {
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "message": message,
      "sender": sender,
      "receiver": receiver,
      "isSeen": isSeen,
      "createdAt": createdAt?.toIso8601String(),
      "senderDetail": senderDetail?.toJson(),
      "receiverDetail": receiverDetail?.toJson(),
    };
  }
}
extension ErDetailToJson on ErDetail {
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "firstName": firstName,
      "lastName": lastName,
      "role": role,
      "email": email,
      "avatar": avatar,
    };
  }
}
