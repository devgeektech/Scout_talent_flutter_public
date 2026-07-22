class AllUsersChatModel {
  AllUsersChatModel({
     this.responseCode,
     this.responseMessage,
     this.data,
     this.totalRecord,
  });

  final num? responseCode;
  final String? responseMessage;
  final List<Datum>? data;
  final num? totalRecord;

  factory AllUsersChatModel.fromJson(Map<String, dynamic> json){
    return AllUsersChatModel(
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
    required this.playerHeight,
    //required this.roPlayerLeg,
    required this.roPlayerPosition,
    required this.parentFirstName,
    required this.parentLastName,
    required this.parentEmail,
    required this.parentPhone,
    required this.parentRelation,
    required this.county,
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
    required this.club,
    required this.country,
    required this.experienceLevel,
    required this.consistency,
    required this.playingStyle,
    required this.technicalAttributes,
    required this.secondaryPosition,
    required this.schoolName,
    required this.schoolAddress,
    required this.schoolPhone,
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
    required this.address,
    required this.ageGroup,
    required this.bio,
    required this.playerLeg,
    required this.playerPosition,
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
  final String? fcmToken;
  final String? playerAge;
  final String? playerHeight;
  //final String? roPlayerLeg;
  final String? roPlayerPosition;
  final String? parentFirstName;
  final String? parentLastName;
  final String? parentEmail;
  final String? parentPhone;
  final String? parentRelation;
  final String? county;
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
  final String? club;
  final String? country;
  final String? experienceLevel;
  final String? consistency;
  final List<dynamic> playingStyle;
  final List<dynamic> technicalAttributes;
  final List<dynamic> secondaryPosition;
  final String? schoolName;
  final String? schoolAddress;
  final String? schoolPhone;
  final bool? isSubscribeNewsLetter;
  final String? currentTeam;
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
  final String? address;
  final String? ageGroup;
  final String? bio;
  final String? playerLeg;
  final String? playerPosition;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
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
      playerHeight: json["playerHeight"],
      //roPlayerLeg: json["roPlayerLeg"],
      roPlayerPosition: json["roPlayerPosition"],
      parentFirstName: json["parentFirstName"],
      parentLastName: json["parentLastName"],
      parentEmail: json["parentEmail"],
      parentPhone: json["parentPhone"],
      parentRelation: json["parentRelation"],
      county: json["county"],
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
      club: json["club"],
      country: json["country"],
      experienceLevel: json["experienceLevel"],
      consistency: json["consistency"],
      playingStyle: json["playingStyle"] == null ? [] : List<dynamic>.from(json["playingStyle"]!.map((x) => x)),
      technicalAttributes: json["technicalAttributes"] == null ? [] : List<dynamic>.from(json["technicalAttributes"]!.map((x) => x)),
      secondaryPosition: json["secondaryPosition"] == null ? [] : List<dynamic>.from(json["secondaryPosition"]!.map((x) => x)),
      schoolName: json["schoolName"],
      schoolAddress: json["schoolAddress"],
      schoolPhone: json["schoolPhone"],
      isSubscribeNewsLetter: json["isSubscribeNewsLetter"],
      currentTeam: json["currentTeam"],
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
      address: json["address"],
      ageGroup: json["ageGroup"],
      bio: json["bio"],
      playerLeg: json["playerLeg"],
      playerPosition: json["playerPosition"],
    );
  }

}
