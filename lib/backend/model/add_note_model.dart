class AddNoteModel {
  AddNoteModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory AddNoteModel.fromJson(Map<String, dynamic> json){
    return AddNoteModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.createdBy,
    required this.isDeleted,
    required this.playerId,
    required this.createdAt,
    required this.note,
    required this.updatedAt,
  });

  final String? id;
  final String? createdBy;
  final bool? isDeleted;
  final String? playerId;
  final DateTime? createdAt;
  final String? note;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      createdBy: json["createdBy"],
      isDeleted: json["isDeleted"],
      playerId: json["playerId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      note: json["note"],
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
