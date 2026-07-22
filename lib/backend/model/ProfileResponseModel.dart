import 'package:scouttalent2/backend/model/playerDetailResponse.dart';

class ProfileResModel {
  ProfileResModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory ProfileResModel.fromJson(Map<String, dynamic> json){
    return ProfileResModel(
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
    required this.address,
    required this.ageGroup,
    required this.bio,
    required this.club,
    required this.competitionLevel,
    required this.contractEnd,
    required this.contractStart,
    required this.countryCode,
    required this.county,
    required this.currentClub,
    required this.cv,
    required this.dribblesCompleted,
    required this.duelsWon,
    required this.height,
    required this.matches,
    required this.medicalCertificate,
    required this.nationality,
    required this.passAccuracy,
    required this.passCompletion,
    required this.playerHeight,
    required this.playerLeg,
    required this.playerPosition,
    required this.position,
    required this.preferredFoot,
    required this.roCompetitionLevel,
    required this.roNationality,
    //required this.roPlayerLeg,
    required this.roPlayerPosition,
    required this.roPosition,
    required this.roPreferredFoot,
    required this.schoolAddress,
    required this.schoolName,
    required this.schoolPhone,
    required this.season,
    required this.shotsOnTarget,
    required this.squadNumber,
    required this.weight,
    required this.hasSubscription,
    required this.subscriptionStatus,
    required this.isUnlimited,
    required this.profileCompletion,
    required this.videos,
    required this.playerLimit,
    required this.playerVideos,
    required this.note,
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
  final int? callUps;
  final dynamic caps;
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
  final List<PlayerCareer> career;
  final List<Trophies> trophies;
  final DateTime? joinedAt;
  final DateTime? otpExipredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final String? address;
  final String? ageGroup;
  final String? bio;
  final String? club;
  final String? competitionLevel;
  final DateTime? contractEnd;
  final DateTime? contractStart;
  final String? countryCode;
  final String? county;
  final String? currentClub;
  final String? cv;
  final int? dribblesCompleted;
  final int? duelsWon;
  final num? height;
  final num? matches;
  final String? medicalCertificate;
  final String? nationality;
  final int? passAccuracy;
  final int? passCompletion;
  final int? playerHeight;
  final String? playerLeg;
  final String? playerPosition;
  final String? position;
  final String? preferredFoot;
  final String? roCompetitionLevel;
  final String? roNationality;
  //final String? roPlayerLeg;
  final String? roPlayerPosition;
  final String? roPosition;
  final String? roPreferredFoot;
  final String? schoolAddress;
  final String? schoolName;
  final String? schoolPhone;
  final String? season;
  final int? shotsOnTarget;
  final int? squadNumber;
  final num? weight;
  final bool? hasSubscription;
  final String? subscriptionStatus;
  final bool? isUnlimited;
  final num? profileCompletion;
  final num? playerLimit;
  final List<dynamic> videos;
  final List<Videos> playerVideos;
  final List<Heatmap> heatmap;
  String? note;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
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
      career: json["career"] == null ? [] : List<PlayerCareer>.from(json["career"]!.map((x) => PlayerCareer.fromJson(x))),
      trophies: json["trophies"] == null ? [] : List<Trophies>.from(json["trophies"]!.map((x) => Trophies.fromJson(x))),
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      address: json["address"],
      ageGroup: json["ageGroup"],
      bio: json["bio"],
      club: json["club"],
      competitionLevel: json["competitionLevel"],
      contractEnd: DateTime.tryParse(json["contractEnd"] ?? ""),
      contractStart: DateTime.tryParse(json["contractStart"] ?? ""),
      countryCode: json["countryCode"],
      county: json["county"],
      currentClub: json["currentClub"],
      note: json["note"],
      cv: json["cv"],
      dribblesCompleted: json["dribblesCompleted"],
      duelsWon: json["duelsWon"],
      height: json["height"],
      matches: json["matches"],
      medicalCertificate: json["medicalCertificate"],
      nationality: json["nationality"],
      passAccuracy: json["passAccuracy"],
      passCompletion: json["passCompletion"],
      playerHeight: json["height"],
      playerLeg: json["preferredFoot"],
      playerPosition: json["playerPosition"],
      position: json["position"],
      preferredFoot: json["preferredFoot"],
      roCompetitionLevel: json["roCompetitionLevel"],
      roNationality: json["roNationality"],
      //roPlayerLeg: json["roPlayerLeg"],
      roPlayerPosition: json["roPlayerPosition"],
      roPosition: json["roPosition"],
      roPreferredFoot: json["roPreferredFoot"],
      schoolAddress: json["schoolAddress"],
      schoolName: json["schoolName"],
      schoolPhone: json["schoolPhone"],
      season: json["season"],
      shotsOnTarget: json["shotsOnTarget"],
      squadNumber: json["squadNumber"],
      weight: json["weight"],
      hasSubscription: json["hasSubscription"],
      subscriptionStatus: json["subscriptionStatus"],
      isUnlimited: json["isUnlimited"],
      profileCompletion: json["profileCompletion"],
      playerLimit: json["playerLimit"],
      videos: json["videos"] == null ? [] : List<dynamic>.from(json["videos"]!.map((x) => x)),
      playerVideos: json["videos"] == null
          ? []
          : List<Videos>.from(
        json["videos"].map((x) => Videos.fromJson(x)),
      ),
      heatmap: json["heatmap"] == null
          ? []
          : List<Heatmap>.from(
        json["heatmap"].map((x) => Heatmap.fromJson(x)),
      ),
    );
  }

}