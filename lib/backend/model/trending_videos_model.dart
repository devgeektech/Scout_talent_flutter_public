class TrendingVideosModel {
  TrendingVideosModel({
     this.responseCode,
     this.responseMessage,
     this.data,
     this.totalRecord,
  });

  final num? responseCode;
  final String? responseMessage;
  final List<TrendingVideosBody>? data;
  final num? totalRecord;

  factory TrendingVideosModel.fromJson(Map<String, dynamic> json){
    return TrendingVideosModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<TrendingVideosBody>.from(json["data"]!.map((x) => TrendingVideosBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class TrendingVideosBody {
  TrendingVideosBody({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.video,
    required this.description,
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
    required this.likesCount,
    required this.videoDate,
    required this.creator,
  });

  final String? id;
  final String? title;
  final String? thumbnail;
  final String? video;
  final String? description;
  final String? createdBy;
  final List<String> likes;
  final List<String> shares;
  final List<String> comments;
  final String? privacy;
  final bool? isVerified;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final num? likesCount;
  final DateTime? videoDate;
  final Creator? creator;
  bool isLikeBtn = false;
  int likeTotalCount = 0;

  factory TrendingVideosBody.fromJson(Map<String, dynamic> json){
    return TrendingVideosBody(
      id: json["_id"],
      title: json["title"],
      thumbnail: json["thumbnail"],
      video: json["video"],
      description: json["description"],
      createdBy: json["createdBy"],
      likes: json["likes"] == null ? [] : List<String>.from(json["likes"]!.map((x) => x)),
      shares: json["shares"] == null ? [] : List<String>.from(json["shares"]!.map((x) => x)),
      comments: json["comments"] == null ? [] : List<String>.from(json["comments"]!.map((x) => x)),
      privacy: json["privacy"],
      isVerified: json["isVerified"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      likesCount: json["likesCount"],
      videoDate: DateTime.tryParse(json["videoDate"] ?? ""),
      creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
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
    required this.fcmToken,
    required this.playerAge,
    required this.parentFirstName,
    required this.parentLastName,
    required this.parentEmail,
    required this.parentPhone,
    required this.parentRelation,
    required this.referredByAnotherUserCode,
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
    required this.country,
    required this.experienceLevel,
    required this.consistency,
    required this.playingStyle,
    required this.previousClubs,
    required this.technicalAttributes,
    required this.secondaryPosition,
    required this.lang,
    required this.isSubscribeNewsLetter,
    required this.currentTeam,
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
    required this.club,
    required this.competitionLevel,
    required this.contractEnd,
    required this.contractStart,
    required this.countryCode,
    required this.cv,
    required this.dribblesCompleted,
    required this.duelsWon,
    required this.medicalCertificate,
    required this.nationality,
    required this.passAccuracy,
    required this.passCompletion,
    required this.playerHeight,
    required this.playerLeg,
    required this.roCompetitionLevel,
    required this.roNationality,
    required this.shotsOnTarget,
    required this.squadNumber,
    required this.weight,
    required this.matches,
    required this.position,
    required this.roPosition,
    required this.season,
    required this.address,
    required this.ageGroup,
    required this.bio,
    required this.county,
    required this.currentClub,
    required this.height,
    required this.playerPosition,
    required this.preferredFoot,
    required this.roPlayerLeg,
    required this.roPlayerPosition,
    required this.roPreferredFoot,
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
  final dynamic fcmToken;
  final String? playerAge;
  final String? parentFirstName;
  final String? parentLastName;
  final String? parentEmail;
  final String? parentPhone;
  final String? parentRelation;
  final String? referredByAnotherUserCode;
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
  final String? country;
  final String? experienceLevel;
  final String? consistency;
  final List<String> playingStyle;
  final List<dynamic> previousClubs;
  final List<String> technicalAttributes;
  final List<String> secondaryPosition;
  final String? lang;
  final bool? isSubscribeNewsLetter;
  final String? currentTeam;
  final String? otp;
  final List<String> youtubeLinks;
  final bool? isBlocked;
  final bool? isVerified;
  final bool? isFree;
  final DateTime? freePlanStartAt;
  final DateTime? freePlanEndAt;
  final bool? isDeleted;
  final List<Career> career;
  final List<Trophy> trophies;
  final DateTime? joinedAt;
  final DateTime? otpExipredAt;
  final List<dynamic> heatmap;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final String? club;
  final String? competitionLevel;
  final DateTime? contractEnd;
  final DateTime? contractStart;
  final String? countryCode;
  final String? cv;
  final num? dribblesCompleted;
  final num? duelsWon;
  final String? medicalCertificate;
  final String? nationality;
  final num? passAccuracy;
  final num? passCompletion;
  final String? playerHeight;
  final String? playerLeg;
  final String? roCompetitionLevel;
  final String? roNationality;
  final num? shotsOnTarget;
  final num? squadNumber;
  final num? weight;
  final num? matches;
  final String? position;
  final String? roPosition;
  final String? season;
  final String? address;
  final String? ageGroup;
  final String? bio;
  final String? county;
  final String? currentClub;
  final num? height;
  final String? playerPosition;
  final String? preferredFoot;
  final String? roPlayerLeg;
  final String? roPlayerPosition;
  final String? roPreferredFoot;

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
      fcmToken: json["fcmToken"],
      playerAge: json["playerAge"],
      parentFirstName: json["parentFirstName"],
      parentLastName: json["parentLastName"],
      parentEmail: json["parentEmail"],
      parentPhone: json["parentPhone"],
      parentRelation: json["parentRelation"],
      referredByAnotherUserCode: json["referredByAnotherUserCode"],
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
      country: json["country"],
      experienceLevel: json["experienceLevel"],
      consistency: json["consistency"],
      playingStyle: json["playingStyle"] == null ? [] : List<String>.from(json["playingStyle"]!.map((x) => x)),
      previousClubs: json["previousClubs"] == null ? [] : List<dynamic>.from(json["previousClubs"]!.map((x) => x)),
      technicalAttributes: json["technicalAttributes"] == null ? [] : List<String>.from(json["technicalAttributes"]!.map((x) => x)),
      secondaryPosition: json["secondaryPosition"] == null ? [] : List<String>.from(json["secondaryPosition"]!.map((x) => x)),
      lang: json["lang"],
      isSubscribeNewsLetter: json["isSubscribeNewsLetter"],
      currentTeam: json["currentTeam"],
      otp: json["otp"],
      youtubeLinks: json["youtubeLinks"] == null ? [] : List<String>.from(json["youtubeLinks"]!.map((x) => x)),
      isBlocked: json["isBlocked"],
      isVerified: json["isVerified"],
      isFree: json["isFree"],
      freePlanStartAt: DateTime.tryParse(json["freePlanStartAt"] ?? ""),
      freePlanEndAt: DateTime.tryParse(json["freePlanEndAt"] ?? ""),
      isDeleted: json["isDeleted"],
      career: json["career"] == null ? [] : List<Career>.from(json["career"]!.map((x) => Career.fromJson(x))),
      trophies: json["trophies"] == null ? [] : List<Trophy>.from(json["trophies"]!.map((x) => Trophy.fromJson(x))),
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      heatmap: json["heatmap"] == null ? [] : List<dynamic>.from(json["heatmap"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      club: json["club"],
      competitionLevel: json["competitionLevel"],
      contractEnd: DateTime.tryParse(json["contractEnd"] ?? ""),
      contractStart: DateTime.tryParse(json["contractStart"] ?? ""),
      countryCode: json["countryCode"],
      cv: json["cv"],
      dribblesCompleted: json["dribblesCompleted"],
      duelsWon: json["duelsWon"],
      medicalCertificate: json["medicalCertificate"],
      nationality: json["nationality"],
      passAccuracy: json["passAccuracy"],
      passCompletion: json["passCompletion"],
      playerHeight: json["playerHeight"],
      playerLeg: json["playerLeg"],
      roCompetitionLevel: json["roCompetitionLevel"],
      roNationality: json["roNationality"],
      shotsOnTarget: json["shotsOnTarget"],
      squadNumber: json["squadNumber"],
      weight: json["weight"],
      matches: json["matches"],
      position: json["position"],
      roPosition: json["roPosition"],
      season: json["season"],
      address: json["address"],
      ageGroup: json["ageGroup"],
      bio: json["bio"],
      county: json["county"],
      currentClub: json["currentClub"],
      height: json["height"],
      playerPosition: json["playerPosition"],
      preferredFoot: json["preferredFoot"],
      roPlayerLeg: json["roPlayerLeg"],
      roPlayerPosition: json["roPlayerPosition"],
      roPreferredFoot: json["roPreferredFoot"],
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
