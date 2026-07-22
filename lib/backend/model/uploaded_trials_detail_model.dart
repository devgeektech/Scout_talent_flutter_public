class UploadedTrialDetailsModel {
  UploadedTrialDetailsModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory UploadedTrialDetailsModel.fromJson(Map<String, dynamic> json){
    return UploadedTrialDetailsModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.description,
    required this.player,
    required this.drills,
  });

  final String? id;
  final String? name;
  final String? description;
  final Player? player;
  final List<Drill> drills;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      player: json["player"] == null ? null : Player.fromJson(json["player"]),
      drills: json["drills"] == null ? [] : List<Drill>.from(json["drills"]!.map((x) => Drill.fromJson(x))),
    );
  }

}

class Drill {
  Drill({
    required this.srNo,
    required this.title,
    required this.description,
    required this.video,
  });

  final num? srNo;
  final String? title;
  final String? description;
  final String? video;

  factory Drill.fromJson(Map<String, dynamic> json){
    return Drill(
      srNo: json["srNo"],
      title: json["title"],
      description: json["description"],
      video: json["video"],
    );
  }

}

class Player {
  Player({
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  final String? firstName;
  final String? lastName;
  final String? avatar;

  factory Player.fromJson(Map<String, dynamic> json){
    return Player(
      firstName: json["firstName"],
      lastName: json["lastName"],
      avatar: json["avatar"],
    );
  }

}
