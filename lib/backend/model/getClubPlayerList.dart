class GetClubPlayersList {
  int? responseCode;
  String? responseMessage;
  List<ClubPlayers>? data;
  int? totalRecord;

  GetClubPlayersList(
      {this.responseCode, this.responseMessage, this.data, this.totalRecord});

  GetClubPlayersList.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['data'] != null) {
      data = <ClubPlayers>[];
      json['data'].forEach((v) {
        data!.add(ClubPlayers.fromJson(v));
      });
    }
    totalRecord = json['totalRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalRecord'] = totalRecord;
    return data;
  }
}

class ClubPlayers {
  String? sId;
  String? firstName;
  String? lastName;
  String? role;
  String? email;
  String? avatar;
  String? dob;
  bool? stripeAccountOnboarded;
  int? referredUserPercentage;
  int? newUserPercentage;
  String? nationality;
  int? height;
  int? weight;
  String? preferredFoot;
  String? countryCode;
  String? currentClub;
  String? competitionLevel;
  int? squadNumber;
  String? contractStart;
  String? contractEnd;
  String? transferStatus;
  List<Career>? career;
  int? matchesPlayed;
  int? goals;
  int? assists;
  int? minutes;
  int? callUps;
  int? caps;
  int? passCompletion;
  int? duelsWon;
  int? passAccuracy;
  int? shotsOnTarget;
  int? dribblesCompleted;
  String? cv;
  String? medicalCertificate;
  String? privacy;
  String? club;
  String? season;
  int? matches;
  List<Trophies>? trophies;
  String? otp;
  String? otpExipredAt;
  List<String>? youtubeLinks;
  bool? isBlocked;
  bool? isVerified;
  bool? isFree;
  bool? isDeleted;
  String? createdBy;
  String? joinedAt;
  String? createdAt;
  String? updatedAt;
  String? roNationality;
  String? roPreferredFoot;
  String? roCompetitionLevel;
  String? position;
  String? roPosition;

  ClubPlayers(
      {this.sId,
        this.firstName,
        this.lastName,
        this.role,
        this.email,
        this.avatar,
        this.dob,
        this.stripeAccountOnboarded,
        this.referredUserPercentage,
        this.newUserPercentage,
        this.nationality,
        this.height,
        this.weight,
        this.preferredFoot,
        this.countryCode,
        this.currentClub,
        this.competitionLevel,
        this.squadNumber,
        this.contractStart,
        this.contractEnd,
        this.transferStatus,
        this.career,
        this.matchesPlayed,
        this.goals,
        this.assists,
        this.minutes,
        this.callUps,
        this.caps,
        this.passCompletion,
        this.duelsWon,
        this.passAccuracy,
        this.shotsOnTarget,
        this.dribblesCompleted,
        this.cv,
        this.medicalCertificate,
        this.privacy,
        this.club,
        this.season,
        this.matches,
        this.trophies,
        this.otp,
        this.otpExipredAt,
        this.youtubeLinks,
        this.isBlocked,
        this.isVerified,
        this.isFree,
        this.isDeleted,
        this.createdBy,
        this.joinedAt,
        this.createdAt,
        this.updatedAt,
        this.roNationality,
        this.roPreferredFoot,
        this.roCompetitionLevel,
        this.position,
        this.roPosition});

  ClubPlayers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    email = json['email'];
    avatar = json['avatar'];
    dob = json['dob'];
    stripeAccountOnboarded = json['stripeAccountOnboarded'];
    referredUserPercentage = json['referredUserPercentage'];
    newUserPercentage = json['newUserPercentage'];
    nationality = json['nationality'];
    height = json['height'];
    weight = json['weight'];
    preferredFoot = json['preferredFoot'];
    countryCode = json['countryCode'];
    currentClub = json['currentClub'];
    competitionLevel = json['competitionLevel'];
    squadNumber = json['squadNumber'];
    contractStart = json['contractStart'];
    contractEnd = json['contractEnd'];
    transferStatus = json['transferStatus'];
    if (json['career'] != null) {
      career = <Career>[];
      json['career'].forEach((v) {
        career!.add(Career.fromJson(v));
      });
    }
    matchesPlayed = json['matchesPlayed'];
    goals = json['goals'];
    assists = json['assists'];
    minutes = json['minutes'];
    callUps = json['callUps'];
    caps = json['caps'];
    passCompletion = json['passCompletion'];
    duelsWon = json['duelsWon'];
    passAccuracy = json['passAccuracy'];
    shotsOnTarget = json['shotsOnTarget'];
    dribblesCompleted = json['dribblesCompleted'];
    cv = json['cv'];
    medicalCertificate = json['medicalCertificate'];
    privacy = json['privacy'];
    club = json['club'];
    season = json['season'];
    matches = json['matches'];
    if (json['trophies'] != null) {
      trophies = <Trophies>[];
      json['trophies'].forEach((v) {
        trophies!.add(Trophies.fromJson(v));
      });
    }
    otp = json['otp'];
    otpExipredAt = json['otpExipredAt'];
    youtubeLinks = json['youtubeLinks'].cast<String>();
    isBlocked = json['isBlocked'];
    isVerified = json['isVerified'];
    isFree = json['isFree'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'];
    joinedAt = json['joinedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    roNationality = json['roNationality'];
    roPreferredFoot = json['roPreferredFoot'];
    roCompetitionLevel = json['roCompetitionLevel'];
    position = json['position'];
    roPosition = json['roPosition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['role'] = role;
    data['email'] = email;
    data['avatar'] = avatar;
    data['dob'] = dob;
    data['stripeAccountOnboarded'] = stripeAccountOnboarded;
    data['referredUserPercentage'] = referredUserPercentage;
    data['newUserPercentage'] = newUserPercentage;
    data['nationality'] = nationality;
    data['height'] = height;
    data['weight'] = weight;
    data['preferredFoot'] = preferredFoot;
    data['countryCode'] = countryCode;
    data['currentClub'] = currentClub;
    data['competitionLevel'] = competitionLevel;
    data['squadNumber'] = squadNumber;
    data['contractStart'] = contractStart;
    data['contractEnd'] = contractEnd;
    data['transferStatus'] = transferStatus;
    if (career != null) {
      data['career'] = career!.map((v) => v.toJson()).toList();
    }
    data['matchesPlayed'] = matchesPlayed;
    data['goals'] = goals;
    data['assists'] = assists;
    data['minutes'] = minutes;
    data['callUps'] = callUps;
    data['caps'] = caps;
    data['passCompletion'] = passCompletion;
    data['duelsWon'] = duelsWon;
    data['passAccuracy'] = passAccuracy;
    data['shotsOnTarget'] = shotsOnTarget;
    data['dribblesCompleted'] = dribblesCompleted;
    data['cv'] = cv;
    data['medicalCertificate'] = medicalCertificate;
    data['privacy'] = privacy;
    data['club'] = club;
    data['season'] = season;
    data['matches'] = matches;
    if (trophies != null) {
      data['trophies'] = trophies!.map((v) => v.toJson()).toList();
    }
    data['otp'] = otp;
    data['otpExipredAt'] = otpExipredAt;
    data['youtubeLinks'] = youtubeLinks;
    data['isBlocked'] = isBlocked;
    data['isVerified'] = isVerified;
    data['isFree'] = isFree;
    data['isDeleted'] = isDeleted;
    data['createdBy'] = createdBy;
    data['joinedAt'] = joinedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['roNationality'] = roNationality;
    data['roPreferredFoot'] = roPreferredFoot;
    data['roCompetitionLevel'] = roCompetitionLevel;
    data['position'] = position;
    data['roPosition'] = roPosition;
    return data;
  }
}

class Career {
  String? season;
  String? club;
  String? matches;
  String? goals;
  String? minutes;
  String? assists;
  String? sId;

  Career(
      {this.season,
        this.club,
        this.matches,
        this.goals,
        this.minutes,
        this.assists,
        this.sId});

  Career.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    club = json['club'];
    matches = json['matches'];
    goals = json['goals'];
    minutes = json['minutes'];
    assists = json['assists'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['season'] = season;
    data['club'] = club;
    data['matches'] = matches;
    data['goals'] = goals;
    data['minutes'] = minutes;
    data['assists'] = assists;
    data['_id'] = sId;
    return data;
  }
}

class Trophies {
  String? name;
  int? year;
  String? sId;

  Trophies({this.name, this.year, this.sId});

  Trophies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    year = json['year'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['year'] = year;
    data['_id'] = sId;
    return data;
  }
}
