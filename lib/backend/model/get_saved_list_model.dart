
class GetSavedListModel {
  GetSavedListModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<SavedListBody>? data;
  final int? totalRecord;

  factory GetSavedListModel.fromJson(Map<String, dynamic> json){
    return GetSavedListModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<SavedListBody>.from(json["data"]!.map((x) => SavedListBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class SavedListBody {
  SavedListBody({
    required this.id,
    required this.playerId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.playerInfo,
  });

  final String? id;
  final String? playerId;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PlayerInfo? playerInfo;




  factory SavedListBody.fromJson(Map<String, dynamic> json){
    return SavedListBody(
      id: json["_id"],
      playerId: json["playerId"],
      createdBy: json["createdBy"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      playerInfo: json["playerInfo"] == null ? null : PlayerInfo.fromJson(json["playerInfo"]),
    );
  }

}

class PlayerInfo {
  PlayerInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.avatar,
    required this.position,
    required this.roPosition,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? avatar;
  final String? position;
  final String? roPosition;

  bool isSelectSave = true;

  factory PlayerInfo.fromJson(Map<String, dynamic> json){
    return PlayerInfo(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      avatar: json["avatar"],
      position: json["position"],
      roPosition: json["roPosition"],
    );
  }

}
