class RatingRequest {
  int? shooting;
  int? passing;
  int? dribbling;
  int? ballControl;
  int? speed;
  int? strength;
  int? stamina;
  int? agility;
  int? tackling;
  int? positioning;
  int? vision;
  int? offBallMovement;

  RatingRequest(
      {this.shooting,
        this.passing,
        this.dribbling,
        this.ballControl,
        this.speed,
        this.strength,
        this.stamina,
        this.agility,
        this.tackling,
        this.positioning,
        this.vision,
        this.offBallMovement});

  RatingRequest.fromJson(Map<String, dynamic> json) {
    shooting = json['shooting'];
    passing = json['passing'];
    dribbling = json['dribbling'];
    ballControl = json['ballControl'];
    speed = json['speed'];
    strength = json['strength'];
    stamina = json['stamina'];
    agility = json['agility'];
    tackling = json['tackling'];
    positioning = json['positioning'];
    vision = json['vision'];
    offBallMovement = json['offBallMovement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shooting'] = shooting;
    data['passing'] = passing;
    data['dribbling'] = dribbling;
    data['ballControl'] = ballControl;
    data['speed'] = speed;
    data['strength'] = strength;
    data['stamina'] = stamina;
    data['agility'] = agility;
    data['tackling'] = tackling;
    data['positioning'] = positioning;
    data['vision'] = vision;
    data['offBallMovement'] = offBallMovement;
    return data;
  }
}
