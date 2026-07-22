class GetPlayerRating {
  int? responseCode;
  String? responseMessage;
  Data? data;

  GetPlayerRating({this.responseCode, this.responseMessage, this.data});

  GetPlayerRating.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? createdBy;
  bool? isDeleted;
  String? playerId;
  int? agility;
  int? ballControl;
  String? createdAt;
  int? dribbling;
  int? offBallMovement;
  int? passing;
  int? positioning;
  int? shooting;
  int? speed;
  int? stamina;
  int? strength;
  int? tackling;
  String? updatedAt;
  int? vision;

  Data(
      {this.sId,
        this.createdBy,
        this.isDeleted,
        this.playerId,
        this.agility,
        this.ballControl,
        this.createdAt,
        this.dribbling,
        this.offBallMovement,
        this.passing,
        this.positioning,
        this.shooting,
        this.speed,
        this.stamina,
        this.strength,
        this.tackling,
        this.updatedAt,
        this.vision});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdBy = json['createdBy'];
    isDeleted = json['isDeleted'];
    playerId = json['playerId'];
    agility = json['agility'];
    ballControl = json['ballControl'];
    createdAt = json['createdAt'];
    dribbling = json['dribbling'];
    offBallMovement = json['offBallMovement'];
    passing = json['passing'];
    positioning = json['positioning'];
    shooting = json['shooting'];
    speed = json['speed'];
    stamina = json['stamina'];
    strength = json['strength'];
    tackling = json['tackling'];
    updatedAt = json['updatedAt'];
    vision = json['vision'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['createdBy'] = createdBy;
    data['isDeleted'] = isDeleted;
    data['playerId'] = playerId;
    data['agility'] = agility;
    data['ballControl'] = ballControl;
    data['createdAt'] = createdAt;
    data['dribbling'] = dribbling;
    data['offBallMovement'] = offBallMovement;
    data['passing'] = passing;
    data['positioning'] = positioning;
    data['shooting'] = shooting;
    data['speed'] = speed;
    data['stamina'] = stamina;
    data['strength'] = strength;
    data['tackling'] = tackling;
    data['updatedAt'] = updatedAt;
    data['vision'] = vision;
    return data;
  }
}
