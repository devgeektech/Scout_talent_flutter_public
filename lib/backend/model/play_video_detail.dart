class PlayVideoDetailModel {
  PlayVideoDetailModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory PlayVideoDetailModel.fromJson(Map<String, dynamic> json){
    return PlayVideoDetailModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.title,
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
    required this.creator,
    required this.student,
  });

  final String? id;
  final String? title;
  final String? video;
  final String? description;
  final String? player;
  final String? createdBy;
   List<dynamic> likes;
  final List<dynamic> shares;
  final List<dynamic> comments;
  final String? privacy;
  final bool? isVerified;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final Creator? creator;
  final Student? student;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      title: json["title"],
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
      creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
      student: json["student"] == null ? null : Student.fromJson(json["student"]),
    );
  }

}

class Creator {
  Creator({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.password,
    required this.avatar,
    required this.phone,
    required this.dob,
    required this.referralCode,
    required this.stripeAccountOnboarded,
    required this.referredUserPercentage,
    required this.newUserPercentage,
    required this.stripeConnectedAccountId,
    required this.conectedAccountCreateUrl,
    required this.transferStatus,
    required this.matchesPlayed,
    required this.goals,
    required this.assists,
    required this.minutes,
    required this.callUps,
    required this.caps,
    required this.privacy,
    required this.club,
    required this.country,
    required this.experienceLevel,
    required this.consistency,
    required this.isSubscribeNewsLetter,
    required this.otp,
    required this.youtubeLinks,
    required this.isBlocked,
    required this.isVerified,
    required this.isFree,
    required this.freePlanStartAt,
    required this.freePlanEndAt,
    required this.isDeleted,
    required this.career,
    required this.trophies,
    required this.joinedAt,
    required this.otpExipredAt,
    required this.heatmap,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.fcmToken,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? password;
  final String? avatar;
  final String? phone;
  final DateTime? dob;
  final String? referralCode;
  final bool? stripeAccountOnboarded;
  final num? referredUserPercentage;
  final num? newUserPercentage;
  final String? stripeConnectedAccountId;
  final String? conectedAccountCreateUrl;
  final String? transferStatus;
  final num? matchesPlayed;
  final num? goals;
  final num? assists;
  final num? minutes;
  final num? callUps;
  final num? caps;
  final String? privacy;
  final String? club;
  final String? country;
  final String? experienceLevel;
  final String? consistency;
  final bool? isSubscribeNewsLetter;
  final String? otp;
  final List<dynamic> youtubeLinks;
  final bool? isBlocked;
  final bool? isVerified;
  final bool? isFree;
  final DateTime? freePlanStartAt;
  final DateTime? freePlanEndAt;
  final bool? isDeleted;
  final List<dynamic> career;
  final List<dynamic> trophies;
  final DateTime? joinedAt;
  final DateTime? otpExipredAt;
  final List<dynamic> heatmap;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final String? fcmToken;

  factory Creator.fromJson(Map<String, dynamic> json){
    return Creator(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      password: json["password"],
      avatar: json["avatar"],
      phone: json["phone"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      referralCode: json["referralCode"],
      stripeAccountOnboarded: json["stripeAccountOnboarded"],
      referredUserPercentage: json["referredUserPercentage"],
      newUserPercentage: json["newUserPercentage"],
      stripeConnectedAccountId: json["stripeConnectedAccountId"],
      conectedAccountCreateUrl: json["conectedAccountCreateUrl"],
      transferStatus: json["transferStatus"],
      matchesPlayed: json["matchesPlayed"],
      goals: json["goals"],
      assists: json["assists"],
      minutes: json["minutes"],
      callUps: json["callUps"],
      caps: json["caps"],
      privacy: json["privacy"],
      club: json["club"],
      country: json["country"],
      experienceLevel: json["experienceLevel"],
      consistency: json["consistency"],
      isSubscribeNewsLetter: json["isSubscribeNewsLetter"],
      otp: json["otp"],
      youtubeLinks: json["youtubeLinks"] == null ? [] : List<dynamic>.from(json["youtubeLinks"]!.map((x) => x)),
      isBlocked: json["isBlocked"],
      isVerified: json["isVerified"],
      isFree: json["isFree"],
      freePlanStartAt: DateTime.tryParse(json["freePlanStartAt"] ?? ""),
      freePlanEndAt: DateTime.tryParse(json["freePlanEndAt"] ?? ""),
      isDeleted: json["isDeleted"],
      career: json["career"] == null ? [] : List<dynamic>.from(json["career"]!.map((x) => x)),
      trophies: json["trophies"] == null ? [] : List<dynamic>.from(json["trophies"]!.map((x) => x)),
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      heatmap: json["heatmap"] == null ? [] : List<dynamic>.from(json["heatmap"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      fcmToken: json["fcmToken"],
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
    required this.countryCode,
    required this.currentClub,
    required this.competitionLevel,
    required this.roCompetitionLevel,
    required this.squadNumber,
    required this.contractStart,
    required this.contractEnd,
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
    required this.privacy,
    required this.club,
    required this.season,
    required this.matches,
    required this.trophies,
    required this.country,
    required this.experienceLevel,
    required this.consistency,
    required this.otp,
    required this.youtubeLinks,
    required this.isBlocked,
    required this.isVerified,
    required this.isFree,
    required this.isDeleted,
    required this.createdBy,
    required this.joinedAt,
    required this.otpExipredAt,
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
  final dynamic height;
  final dynamic weight;
  final String? countryCode;
  final String? currentClub;
  final String? competitionLevel;
  final String? roCompetitionLevel;
  final dynamic squadNumber;
  final dynamic contractStart;
  final dynamic contractEnd;
  final String? transferStatus;
  final List<dynamic> career;
  final dynamic matchesPlayed;
  final dynamic goals;
  final dynamic assists;
  final dynamic minutes;
  final dynamic callUps;
  final dynamic caps;
  final dynamic passCompletion;
  final dynamic duelsWon;
  final dynamic passAccuracy;
  final dynamic shotsOnTarget;
  final dynamic dribblesCompleted;
  final String? privacy;
  final String? club;
  final String? season;
  final dynamic matches;
  final List<dynamic> trophies;
  final String? country;
  final String? experienceLevel;
  final String? consistency;
  final String? otp;
  final List<dynamic> youtubeLinks;
  final bool? isBlocked;
  final bool? isVerified;
  final bool? isFree;
  final bool? isDeleted;
  final String? createdBy;
  final DateTime? joinedAt;
  final DateTime? otpExipredAt;
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
      countryCode: json["countryCode"],
      currentClub: json["currentClub"],
      competitionLevel: json["competitionLevel"],
      roCompetitionLevel: json["roCompetitionLevel"],
      squadNumber: json["squadNumber"],
      contractStart: json["contractStart"],
      contractEnd: json["contractEnd"],
      transferStatus: json["transferStatus"],
      career: json["career"] == null ? [] : List<dynamic>.from(json["career"]!.map((x) => x)),
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
      privacy: json["privacy"],
      club: json["club"],
      season: json["season"],
      matches: json["matches"],
      trophies: json["trophies"] == null ? [] : List<dynamic>.from(json["trophies"]!.map((x) => x)),
      country: json["country"],
      experienceLevel: json["experienceLevel"],
      consistency: json["consistency"],
      otp: json["otp"],
      youtubeLinks: json["youtubeLinks"] == null ? [] : List<dynamic>.from(json["youtubeLinks"]!.map((x) => x)),
      isBlocked: json["isBlocked"],
      isVerified: json["isVerified"],
      isFree: json["isFree"],
      isDeleted: json["isDeleted"],
      createdBy: json["createdBy"],
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      heatmap: json["heatmap"] == null ? [] : List<dynamic>.from(json["heatmap"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}
// For Data
extension DataCopy on Data {
  Data copyWith({List<dynamic>? likes}) {
    return Data(
      id: id,
      title: title,
      video: video,
      description: description,
      player: player,
      createdBy: createdBy,
      likes: likes ?? this.likes,
      shares: shares,
      comments: comments,
      privacy: privacy,
      isVerified: isVerified,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
      creator: creator,
      student: student,
    );
  }
}

// For PlayVideoDetailModel
extension PlayVideoDetailCopy on PlayVideoDetailModel {
  PlayVideoDetailModel copyWith({Data? data}) {
    return PlayVideoDetailModel(
      responseCode: responseCode,
      responseMessage: responseMessage,
      data: data ?? this.data,
    );
  }
}
