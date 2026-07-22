class LoginResModel {
  LoginResModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory LoginResModel.fromJson(Map<String, dynamic> json){
    return LoginResModel(
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
    required this.referralCode,
    required this.stripeAccountOnboarded,
    required this.restoreSubscription,
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
    required this.isSubscribeNewsLetter,
    required this.otp,
    required this.otpExipredAt,
    required this.youtubeLinks,
    required this.isBlocked,
    required this.isVerified,
    required this.isFree,
    required this.hasSubscription,
    required this.subscriptionStatus,
    required this.isUnlimited,
    required this.isDeleted,
    required this.career,
    required this.trophies,
    required this.joinedAt,
    required this.heatmap,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.token,
    required this.playerLimit,
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
  final bool? restoreSubscription;
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
  final bool? isSubscribeNewsLetter;
  final String? otp;
  final DateTime? otpExipredAt;
  final List<dynamic> youtubeLinks;
  final bool? isBlocked;
  final bool? isVerified;
  final bool? isFree;
  final bool? hasSubscription;
  final String? subscriptionStatus;
  final bool? isUnlimited;
  final bool? isDeleted;
  final List<dynamic> career;
  final List<dynamic> trophies;
  final DateTime? joinedAt;
  final List<dynamic> heatmap;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final String? token;
  final num? playerLimit;

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
      referralCode: json["referralCode"],
      stripeAccountOnboarded: json["stripeAccountOnboarded"],
      restoreSubscription: json["restoreSubscription"],
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
      playerLimit: json["playerLimit"],
      privacy: json["privacy"],
      club: json["club"],
      isSubscribeNewsLetter: json["isSubscribeNewsLetter"],
      otp: json["otp"],
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      youtubeLinks: json["youtubeLinks"] == null ? [] : List<dynamic>.from(json["youtubeLinks"]!.map((x) => x)),
      isBlocked: json["isBlocked"],
      isVerified: json["isVerified"],
      isFree: json["isFree"],
      hasSubscription: json["hasSubscription"],
      subscriptionStatus: json["subscriptionStatus"],
      isUnlimited: json["isUnlimited"],
      isDeleted: json["isDeleted"],
      career: json["career"] == null ? [] : List<dynamic>.from(json["career"]!.map((x) => x)),
      trophies: json["trophies"] == null ? [] : List<dynamic>.from(json["trophies"]!.map((x) => x)),
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      heatmap: json["heatmap"] == null ? [] : List<dynamic>.from(json["heatmap"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      token: json["token"],
    );
  }

}
