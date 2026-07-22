class GetMyMessagesChatModel {
  GetMyMessagesChatModel({
     this.responseCode,
     this.responseMessage,
     this.data,
     this.totalRecord,
  });

  final num? responseCode;
  final String? responseMessage;
  final List<RoomMessages>?data;
  final num? totalRecord;

  factory GetMyMessagesChatModel.fromJson(Map<String, dynamic> json){
    return GetMyMessagesChatModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<RoomMessages>.from(json["data"]!.map((x) => RoomMessages.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class RoomMessages {
  RoomMessages({
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

  factory RoomMessages.fromJson(Map<String, dynamic> json){
    return RoomMessages(
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
    required this.email,
    required this.avatar,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;

  factory ErDetail.fromJson(Map<String, dynamic> json){
    return ErDetail(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      avatar: json["avatar"],
    );
  }

}
