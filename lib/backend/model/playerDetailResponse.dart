import '../../utils/utils.dart';

class GetPlayerDetailModal {
  int? code;
  String? message;
  Data? data;
  int? totalRecord;

  GetPlayerDetailModal({this.code, this.message, this.data, this.totalRecord});

  GetPlayerDetailModal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    totalRecord = json['totalRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['totalRecord'] = totalRecord;
    return data;
  }
}

class Data {
  String? sId;
  String? firstName;
  String? lastName;
  String? role;
  String? email;
  String? avatar;
  String? dob;
  String? playerAge;
  bool? stripeAccountOnboarded;
  int? referredUserPercentage;
  int? newUserPercentage;
  String? nationality;
  String? roNationality;
  int? height;
  String? playerHeight;
  int? weight;
  String? preferredFoot;
  String? playerLeg;
  String? countryCode;
  String? currentClub;
  String? currentTeam;
  String? competitionLevel;
  String? roCompetitionLevel;
  int? squadNumber;
  String? contractStart;
  String? contractEnd;
  String? position;
  String? playerPosition;
  String? roPosition;
  String? roPlayerPosition;
  String? transferStatus;
  List<PlayerCareer>? career;
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
  String? country;
  String? experienceLevel;
  String? consistency;
  List<String>? youtubeLinks;
  bool? isBlocked;
  bool? isVerified;
  bool? isFree;
  bool? isDeleted;
  String? createdBy;
  String? joinedAt;
  List<Heatmap>? heatmap;
  String? createdAt;
  String? updatedAt;
  String? note;
  int? iV;
  List<Videos>? playerVideos;
  List<String>? playingStyle;
  List<String>? technicalAttributes;
  List<String>? secondaryPosition;
  String?county;

  Data(
      {this.sId,
        this.firstName,
        this.lastName,
        this.role,
        this.email,
        this.avatar,
        this.dob,
        this.playerAge,
        this.stripeAccountOnboarded,
        this.referredUserPercentage,
        this.newUserPercentage,
        this.nationality,
        this.roNationality,
        this.height,
        this.playerHeight,
        this.weight,
        this.preferredFoot,
        this.playerLeg,
        this.countryCode,
        this.currentClub,
        this.currentTeam,
        this.competitionLevel,
        this.roCompetitionLevel,
        this.squadNumber,
        this.contractStart,
        this.contractEnd,
        this.position,
        this.playerPosition,
        this.roPosition,
        this.roPlayerPosition,
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
        this.country,
        this.experienceLevel,
        this.consistency,
        this.youtubeLinks,
        this.isBlocked,
        this.isVerified,
        this.isFree,
        this.isDeleted,
        this.createdBy,
        this.joinedAt,
        this.heatmap,
        this.createdAt,
        this.updatedAt,
        this.note,
        this.iV,
        this.playerVideos,
        this.playingStyle,
        this.technicalAttributes,
        this.secondaryPosition,
        this.county,
      });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    email = json['email'];
    avatar = json['avatar'];
    dob = json['dob'];
    playerAge = json['playerAge'];
    stripeAccountOnboarded = json['stripeAccountOnboarded'];
    referredUserPercentage = json['referredUserPercentage'];
    newUserPercentage = json['newUserPercentage'];
    nationality = json['nationality'];
    roNationality = json['roNationality'];
    height = json['height'];
    playerHeight = json['playerHeight'];
    weight = json['weight'];
    preferredFoot = json['preferredFoot'];
    playerLeg = json['playerLeg'];
    countryCode = json['countryCode'];
    currentClub = json['currentClub'];
    currentTeam = json['currentTeam'];
    competitionLevel = json['competitionLevel'];
    roCompetitionLevel = json['roCompetitionLevel'];
    squadNumber = json['squadNumber'];
    contractStart = json['contractStart'];
    contractEnd = json['contractEnd'];
    position = json['position'];
    playerPosition = json['playerPosition'];
    roPosition = json['roPosition'];
    roPlayerPosition = json['roPlayerPosition'];
    transferStatus = json['transferStatus'];
    if (json['career'] != null) {
      career = <PlayerCareer>[];
      json['career'].forEach((v) {
        career!.add(PlayerCareer.fromJson(v));
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
    country = json['country'];
    experienceLevel = json['experienceLevel'];
    consistency = json['consistency'];
    youtubeLinks = json['youtubeLinks'].cast<String>();
    isBlocked = json['isBlocked'];
    isVerified = json['isVerified'];
    isFree = json['isFree'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'];
    joinedAt = json['joinedAt'];
    if (json['heatmap'] != null) {
      heatmap = <Heatmap>[];
      json['heatmap'].forEach((v) {
        heatmap!.add(Heatmap.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    note = json['note'];
    iV = json['__v'];
    playingStyle = json['playingStyle'].cast<String>();
    technicalAttributes = json['technicalAttributes'].cast<String>();
    secondaryPosition = json['secondaryPosition'].cast<String>();
    if (json['videos'] != null) {
      playerVideos = <Videos>[];
      json['videos'].forEach((v) {
        playerVideos!.add(new Videos.fromJson(v));
      });
    }
    county = json['county'];
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
    data['playerAge'] = playerAge;
    data['stripeAccountOnboarded'] = stripeAccountOnboarded;
    data['referredUserPercentage'] = referredUserPercentage;
    data['newUserPercentage'] = newUserPercentage;
    data['nationality'] = nationality;
    data['roNationality'] = roNationality;
    data['height'] = height;
    data['playerHeight'] = playerHeight;
    data['weight'] = weight;
    data['preferredFoot'] = preferredFoot;
    data['playerLeg'] = playerLeg;
    data['countryCode'] = countryCode;
    data['currentClub'] = currentClub;
    data['currentTeam'] = currentTeam;
    data['competitionLevel'] = competitionLevel;
    data['roCompetitionLevel'] = roCompetitionLevel;
    data['squadNumber'] = squadNumber;
    data['contractStart'] = contractStart;
    data['contractEnd'] = contractEnd;
    data['position'] = position;
    data['playerPosition'] = playerPosition;
    data['roPosition'] = roPosition;
    data['roPlayerPosition'] = roPlayerPosition;
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
    if (heatmap != null) {
      data['heatmap'] = heatmap!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['note'] = this.note;
    data['__v'] = this.iV;
    data['playingStyle'] = this.playingStyle;
    data['technicalAttributes'] = this.technicalAttributes;
    data['secondaryPosition'] = this.secondaryPosition;
    if (this.playerVideos != null) {
      data['videos'] = this.playerVideos!.map((v) => v.toJson()).toList();
    }
    data['county'] = county;
    return data;
  }

  String get displayHeight {
    if (height != null) return height.toString();
    if (playerHeight != null && playerHeight!.isNotEmpty) {
      return playerHeight!;
    }
    return "N/A";
  }

  String get displayCurrentTeamClub {
    if (currentClub != null) return currentClub.toString();
    if (currentTeam != null && currentTeam!.isNotEmpty) {
      return currentTeam!;
    }
    return "N/A";
  }

  String get displayPreferredFoot {
    if (preferredFoot != null && preferredFoot!.isNotEmpty) {
      return preferredFoot!;
    }
    if (playerLeg != null && playerLeg!.isNotEmpty) {
      return playerLeg!;
    }
    return "N/A";
  }

  String get displayDob {
    if (dob != null && dob!.isNotEmpty) {
      return dob!;
    }
    return '';
  }

  /// ---- AGE (priority-based) ----
  String get displayAge {
    // // 1️⃣ If backend directly gives age (player API)
    // if (playerAge != null && playerAge!.isNotEmpty) {
    //   return playerAge!;
    // }

    // 2️⃣ Else calculate from DOB (clubPlayer API)
    if (dob != null && dob!.isNotEmpty) {
      return getAgeFromDobString(dob!);
    }

    // 3️⃣ Fallback
    return "N/A";
  }

  String getDisplayPosition(String lang) {
    final isRo = lang == 'ro';

    if (isRo) {
      // Romanian priority
      return roPosition?.isNotEmpty == true
          ? roPosition!
          : roPlayerPosition?.isNotEmpty == true
          ? roPlayerPosition!
          : position?.isNotEmpty == true
          ? position!
          : playerPosition?.isNotEmpty == true
          ? playerPosition!
          : "N/A";
    } else {
      // English priority
      return position?.isNotEmpty == true
          ? position!
          : playerPosition?.isNotEmpty == true
          ? playerPosition!
          : roPosition?.isNotEmpty == true
          ? roPosition!
          : roPlayerPosition?.isNotEmpty == true
          ? roPlayerPosition!
          : "N/A";
    }
  }
}

class PlayerCareer {
  String? season;
  String? club;
  String? matches;
  String? goals;
  String? minutes;
  String? assists;
  String? sId;

  PlayerCareer(
      {this.season,
        this.club,
        this.matches,
        this.goals,
        this.minutes,
        this.assists,
        this.sId});

  PlayerCareer.fromJson(Map<String, dynamic> json) {
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
  String? icon;

  Trophies({this.name, this.year, this.sId});

  Trophies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    year = json['year'];
    sId = json['_id'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['year'] = year;
    data['_id'] = sId;
    data['icon'] = icon;
    return data;
  }
}
class Heatmap {
  String? scope;
  List<Points>? points;
  String? sId;

  Heatmap({this.scope, this.points, this.sId});

  Heatmap.fromJson(Map<String, dynamic> json) {
    scope = json['scope'];
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points!.add(Points.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scope'] = scope;
    if (points != null) {
      data['points'] = points!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    return data;
  }
}

class Points {
  String? matchId;
  dynamic x;
  dynamic y;
  String? sId;

  Points({this.matchId, this.x, this.y, this.sId});

  Points.fromJson(Map<String, dynamic> json) {
    matchId = json['match_id'];
    x = json['x'];
    y = json['y'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['match_id'] = matchId;
    data['x'] = x;
    data['y'] = y;
    data['_id'] = sId;
    return data;
  }
}
class Videos {
  String? sId;
  String? title;
  String? thumbnail;
  String? video;
  String? description;
  String? player;
  String? createdBy;
  // List<Null>? likes;
  // List<Null>? shares;
  // List<Null>? comments;
  String? privacy;
  bool? isVerified;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Videos(
      {this.sId,
        this.title,
        this.thumbnail,
        this.video,
        this.description,
        this.player,
        this.createdBy,
        // this.likes,
        // this.shares,
        // this.comments,
        this.privacy,
        this.isVerified,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Videos.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    description = json['description'];
    player = json['player'];
    createdBy = json['createdBy'];
    // if (json['likes'] != null) {
    //   likes = <Null>[];
    //   json['likes'].forEach((v) {
    //     likes!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['shares'] != null) {
    //   shares = <Null>[];
    //   json['shares'].forEach((v) {
    //     shares!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['comments'] != null) {
    //   comments = <Null>[];
    //   json['comments'].forEach((v) {
    //     comments!.add(new Null.fromJson(v));
    //   });
    // }
    privacy = json['privacy'];
    isVerified = json['isVerified'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['video'] = this.video;
    data['description'] = this.description;
    data['player'] = this.player;
    data['createdBy'] = this.createdBy;
    // if (this.likes != null) {
    //   data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    // }
    // if (this.shares != null) {
    //   data['shares'] = this.shares!.map((v) => v.toJson()).toList();
    // }
    // if (this.comments != null) {
    //   data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    // }
    data['privacy'] = this.privacy;
    data['isVerified'] = this.isVerified;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}