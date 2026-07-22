class AuthModel {
  AuthModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory AuthModel.fromJson(Map<String, dynamic> json){
    return AuthModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
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
    required this.isSubscribeNewsLetter,
    required this.otp,
    required this.otpExipredAt,
    required this.youtubeLinks,
    required this.isBlocked,
    required this.isVerified,
    required this.isFree,
    required this.isDeleted,
    required this.id,
    required this.career,
    required this.trophies,
    required this.joinedAt,
    required this.heatmap,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
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
  final bool? isSubscribeNewsLetter;
  final String? otp;
  final DateTime? otpExipredAt;
  final List<dynamic> youtubeLinks;
  final bool? isBlocked;
  final bool? isVerified;
  final bool? isFree;
  final bool? isDeleted;
  final String? id;
  final List<dynamic> career;
  final List<dynamic> trophies;
  final DateTime? joinedAt;
  final List<dynamic> heatmap;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
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
      isSubscribeNewsLetter: json["isSubscribeNewsLetter"],
      otp: json["otp"],
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      youtubeLinks: json["youtubeLinks"] == null ? [] : List<dynamic>.from(json["youtubeLinks"]!.map((x) => x)),
      isBlocked: json["isBlocked"],
      isVerified: json["isVerified"],
      isFree: json["isFree"],
      isDeleted: json["isDeleted"],
      id: json["_id"],
      career: json["career"] == null ? [] : List<dynamic>.from(json["career"]!.map((x) => x)),
      trophies: json["trophies"] == null ? [] : List<dynamic>.from(json["trophies"]!.map((x) => x)),
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      heatmap: json["heatmap"] == null ? [] : List<dynamic>.from(json["heatmap"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
