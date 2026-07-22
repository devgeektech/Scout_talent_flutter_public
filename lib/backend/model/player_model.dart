

class PlayerModel {
  PlayerModel({
    required this.responseCode,
    required this.responseMessage,
    required this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final Data? data;

  factory PlayerModel.fromJson(Map<String, dynamic> json){
    return PlayerModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
    required this.height,
    required this.weight,
    required this.age,
    required this.position,
    required this.roPosition,
    required this.preferredFoot,
    required this.roPreferredFoot,
    required this.nationality,
    required this.roNationality,
    required this.county,
    required this.shooting,
    required this.passing,
    required this.dribbling,
    required this.ballControl,
    required this.speed,
    required this.strength,
    required this.stamina,
    required this.agility,
    required this.tackling,
    required this.positioning,
    required this.vision,
    required this.offBallMovement,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final int? height;
  final int? weight;
  final int? age;
  final String? position;
  final String? roPosition;
  final String? preferredFoot;
  final String? roPreferredFoot;
  final String? nationality;
  final String? roNationality;
  final String? county;
  final num? shooting;
  final num? passing;
  final num? dribbling;
  final num? ballControl;
  final num? speed;
  final num? strength;
  final num? stamina;
  final num? agility;
  final num? tackling;
  final num? positioning;
  final num? vision;
  final num? offBallMovement;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      avatar: json["avatar"],
      height: json["height"],
      weight: json["weight"],
      age: json["age"],
      position: json["position"],
      roPosition: json["roPosition"],
      preferredFoot: json["preferredFoot"],
      roPreferredFoot: json["roPreferredFoot"],
      nationality: json["nationality"],
      roNationality: json["roNationality"],
      county: json["county"],
      shooting: json["shooting"],
      passing: json["passing"],
      dribbling: json["dribbling"],
      ballControl: json["ballControl"],
      speed: json["speed"],
      strength: json["strength"],
      stamina: json["stamina"],
      agility: json["agility"],
      tackling: json["tackling"],
      positioning: json["positioning"],
      vision: json["vision"],
      offBallMovement: json["offBallMovement"],
    );
  }
}