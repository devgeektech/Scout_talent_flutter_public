
class GetAllPlayerListModel {
  GetAllPlayerListModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final Data? data;
  final int? totalRecord;

  factory GetAllPlayerListModel.fromJson(Map<String, dynamic> json){
    return GetAllPlayerListModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      totalRecord: json["totalRecord"],
    );
  }

}

class Data {
  Data({
    required this.totalComparePLayers,
    required this.totalSavedPlayers,
    required this.data,
  });

  final int? totalComparePLayers;
  final int? totalSavedPlayers;
  final List<PlayerListBody> data;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      totalComparePLayers: json["totalComparePlayers"],
      totalSavedPlayers: json["totalSavedPlayers"],
      data: json["data"] == null ? [] : List<PlayerListBody>.from(json["data"]!.map((x) => PlayerListBody.fromJson(x))),
    );
  }

}

class PlayerListBody {
  PlayerListBody({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.avatar,
    required this.isSaved,
    required this.isRated,
    required this.isCompared,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? avatar;
  final bool? isSaved;
  final bool? isRated;
  final bool? isCompared;

  bool isSelectSave = false;
  bool isSelectRate = false;
  bool isAddToCard = false;

  factory PlayerListBody.fromJson(Map<String, dynamic> json){
    return PlayerListBody(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      avatar: json["avatar"],
      isSaved: json["isSaved"],
      isRated: json["isRated"],
      isCompared: json["isCompared"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "role": role,
    "email": email,
    "avatar": avatar,
    "isSaved": isSaved,
    "isRated": isRated,
    "isCompared": isCompared,
  };

}

