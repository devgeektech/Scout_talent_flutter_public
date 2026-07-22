class UploadedVideoListingModel {
  UploadedVideoListingModel({
     this.responseCode,
     this.responseMessage,
     this.data,
     this.totalRecord,
  });

  final num? responseCode;
  final String? responseMessage;
  final List<Datum>? data;
  final num? totalRecord;

  factory UploadedVideoListingModel.fromJson(Map<String, dynamic> json){
    return UploadedVideoListingModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.video,
    required this.description,
    required this.player,
    required this.createdBy,
    required this.likes,
    required this.shares,
    required this.comments,
    required this.privacy,
    required this.isVerified,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.student,
    required this.playerName,
    required this.playerNationality,
    required this.playerHeight,
    required this.playerPreferredFoot,
    required this.playerCurrentClub,
    required this.avatar,
    required this.role,
  });

  final String? id;
  final String? title;
  final String? thumbnail;
  final String? video;
  final String? description;
  final String? player;
  final String? createdBy;
  final List<dynamic> likes;
  final List<dynamic> shares;
  final List<dynamic> comments;
  final String? privacy;
  final bool? isVerified;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final Student? student;
  final String? playerName;
  final String? playerNationality;
  final num? playerHeight;
  final String? playerPreferredFoot;
  final String? playerCurrentClub;
  final String? avatar;
  final String? role;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["_id"],
      title: json["title"],
      thumbnail: json["thumbnail"],
      video: json["video"],
      description: json["description"],
      player: json["player"],
      createdBy: json["createdBy"],
      likes: json["likes"] == null ? [] : List<dynamic>.from(json["likes"]!.map((x) => x)),
      shares: json["shares"] == null ? [] : List<dynamic>.from(json["shares"]!.map((x) => x)),
      comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
      privacy: json["privacy"],
      isVerified: json["isVerified"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      student: json["student"] == null ? null : Student.fromJson(json["student"]),
      playerName: json["playerName"],
      playerNationality: json["playerNationality"],
      playerHeight: json["playerHeight"],
      playerPreferredFoot: json["playerPreferredFoot"],
      playerCurrentClub: json["playerCurrentClub"],
      avatar: json["avatar"],
      role: json["role"],
    );
  }

}

class Student {
  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.avatar,
    required this.dob,
    required this.stripeAccountOnboarded,
    required this.referredUserPercentage,
    required this.newUserPercentage,
    required this.nationality,
    required this.roNationality,
    required this.height,
    required this.weight,
    required this.preferredFoot,
    required this.countryCode,
    required this.roPreferredFoot,
    required this.currentClub,
    required this.competitionLevel,
    required this.roCompetitionLevel,
    required this.squadNumber,
    required this.contractStart,
    required this.contractEnd,
    required this.position,
    required this.roPosition,
    required this.transferStatus,
    required this.career,
    required this.matchesPlayed,
    required this.goals,
    required this.assists,
    required this.minutes,
    required this.callUps,
    required this.caps,
    required this.passCompletion,
    required this.duelsWon,
    required this.passAccuracy,
    required this.shotsOnTarget,
    required this.dribblesCompleted,
    required this.cv,
    required this.medicalCertificate,
    required this.privacy,
    required this.club,
    required this.season,
    required this.matches,
    required this.trophies,
    required this.otp,
    required this.otpExipredAt,
    required this.youtubeLinks,
    required this.isBlocked,
    required this.isVerified,
    required this.isFree,
    required this.isDeleted,
    required this.createdBy,
    required this.joinedAt,
    required this.heatmap,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? avatar;
  final DateTime? dob;
  final bool? stripeAccountOnboarded;
  final num? referredUserPercentage;
  final num? newUserPercentage;
  final String? nationality;
  final String? roNationality;
  final num? height;
  final num? weight;
  final String? preferredFoot;
  final String? countryCode;
  final String? roPreferredFoot;
  final String? currentClub;
  final String? competitionLevel;
  final String? roCompetitionLevel;
  final num? squadNumber;
  final DateTime? contractStart;
  final DateTime? contractEnd;
  final String? position;
  final String? roPosition;
  final String? transferStatus;
  final List<Career> career;
  final num? matchesPlayed;
  final num? goals;
  final num? assists;
  final num? minutes;
  final num? callUps;
  final num? caps;
  final num? passCompletion;
  final num? duelsWon;
  final num? passAccuracy;
  final num? shotsOnTarget;
  final num? dribblesCompleted;
  final String? cv;
  final String? medicalCertificate;
  final String? privacy;
  final String? club;
  final String? season;
  final num? matches;
  final List<Trophy> trophies;
  final String? otp;
  final DateTime? otpExipredAt;
  final List<dynamic> youtubeLinks;
  final bool? isBlocked;
  final bool? isVerified;
  final bool? isFree;
  final bool? isDeleted;
  final String? createdBy;
  final DateTime? joinedAt;
  final List<dynamic> heatmap;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  factory Student.fromJson(Map<String, dynamic> json){
    return Student(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      avatar: json["avatar"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      stripeAccountOnboarded: json["stripeAccountOnboarded"],
      referredUserPercentage: json["referredUserPercentage"],
      newUserPercentage: json["newUserPercentage"],
      nationality: json["nationality"],
      roNationality: json["roNationality"],
      height: json["height"],
      weight: json["weight"],
      preferredFoot: json["preferredFoot"],
      countryCode: json["countryCode"],
      roPreferredFoot: json["roPreferredFoot"],
      currentClub: json["currentClub"],
      competitionLevel: json["competitionLevel"],
      roCompetitionLevel: json["roCompetitionLevel"],
      squadNumber: json["squadNumber"],
      contractStart: DateTime.tryParse(json["contractStart"] ?? ""),
      contractEnd: DateTime.tryParse(json["contractEnd"] ?? ""),
      position: json["position"],
      roPosition: json["roPosition"],
      transferStatus: json["transferStatus"],
      career: json["career"] == null ? [] : List<Career>.from(json["career"]!.map((x) => Career.fromJson(x))),
      matchesPlayed: json["matchesPlayed"],
      goals: json["goals"],
      assists: json["assists"],
      minutes: json["minutes"],
      callUps: json["callUps"],
      caps: json["caps"],
      passCompletion: json["passCompletion"],
      duelsWon: json["duelsWon"],
      passAccuracy: json["passAccuracy"],
      shotsOnTarget: json["shotsOnTarget"],
      dribblesCompleted: json["dribblesCompleted"],
      cv: json["cv"],
      medicalCertificate: json["medicalCertificate"],
      privacy: json["privacy"],
      club: json["club"],
      season: json["season"],
      matches: json["matches"],
      trophies: json["trophies"] == null ? [] : List<Trophy>.from(json["trophies"]!.map((x) => Trophy.fromJson(x))),
      otp: json["otp"],
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      youtubeLinks: json["youtubeLinks"] == null ? [] : List<dynamic>.from(json["youtubeLinks"]!.map((x) => x)),
      isBlocked: json["isBlocked"],
      isVerified: json["isVerified"],
      isFree: json["isFree"],
      isDeleted: json["isDeleted"],
      createdBy: json["createdBy"],
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      heatmap: json["heatmap"] == null ? [] : List<dynamic>.from(json["heatmap"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}

class Career {
  Career({
    required this.season,
    required this.club,
    required this.matches,
    required this.goals,
    required this.minutes,
    required this.assists,
    required this.id,
  });

  final String? season;
  final String? club;
  final String? matches;
  final String? goals;
  final String? minutes;
  final String? assists;
  final String? id;

  factory Career.fromJson(Map<String, dynamic> json){
    return Career(
      season: json["season"],
      club: json["club"],
      matches: json["matches"],
      goals: json["goals"],
      minutes: json["minutes"],
      assists: json["assists"],
      id: json["_id"],
    );
  }

}

class Trophy {
  Trophy({
    required this.name,
    required this.year,
    required this.icon,
    required this.id,
  });

  final String? name;
  final num? year;
  final String? icon;
  final String? id;

  factory Trophy.fromJson(Map<String, dynamic> json){
    return Trophy(
      name: json["name"],
      year: json["year"],
      icon: json["icon"],
      id: json["_id"],
    );
  }

}
