class VideoCommentListModel {
  VideoCommentListModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<VideoCommentBody>? data;
  final int? totalRecord;

  factory VideoCommentListModel.fromJson(Map<String, dynamic> json){
    return VideoCommentListModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<VideoCommentBody>.from(json["data"]!.map((x) => VideoCommentBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class VideoCommentBody {
  VideoCommentBody({
    required this.id,
    required this.message,
    required this.video,
    required this.createdBy,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.creator,
  });

  final String? id;
  final String? message;
  final String? video;
  final String? createdBy;
  final List<dynamic> likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final Creator? creator;

  factory VideoCommentBody.fromJson(Map<String, dynamic> json){
    return VideoCommentBody(
      id: json["_id"],
      message: json["message"],
      video: json["video"],
      createdBy: json["createdBy"],
      likes: json["likes"] == null ? [] : List<dynamic>.from(json["likes"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
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
    required this.career,
    required this.trophies,
    required this.joinedAt,
    required this.heatmap,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.address,
    required this.ageGroup,
    required this.bio,
    required this.county,
    required this.parentEmail,
    required this.parentFirstName,
    required this.parentLastName,
    required this.parentPhone,
    required this.parentRelation,
    required this.playerAge,
    required this.playerHeight,
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
  final String? referralCode;
  final bool? stripeAccountOnboarded;
  final int? referredUserPercentage;
  final int? newUserPercentage;
  final String? stripeConnectedAccountId;
  final String? conectedAccountCreateUrl;
  final String? transferStatus;
  final int? matchesPlayed;
  final int? goals;
  final int? assists;
  final int? minutes;
  final int? callUps;
  final int? caps;
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
  final List<dynamic> career;
  final List<dynamic> trophies;
  final DateTime? joinedAt;
  final List<dynamic> heatmap;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? address;
  final String? ageGroup;
  final String? bio;
  final String? county;
  final String? parentEmail;
  final String? parentFirstName;
  final String? parentLastName;
  final String? parentPhone;
  final String? parentRelation;
  final String? playerAge;
  final String? playerHeight;
  final String? playerLeg;
  final String? playerPosition;

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
      isSubscribeNewsLetter: json["isSubscribeNewsLetter"],
      otp: json["otp"],
      otpExipredAt: DateTime.tryParse(json["otpExipredAt"] ?? ""),
      youtubeLinks: json["youtubeLinks"] == null ? [] : List<dynamic>.from(json["youtubeLinks"]!.map((x) => x)),
      isBlocked: json["isBlocked"],
      isVerified: json["isVerified"],
      isFree: json["isFree"],
      isDeleted: json["isDeleted"],
      career: json["career"] == null ? [] : List<dynamic>.from(json["career"]!.map((x) => x)),
      trophies: json["trophies"] == null ? [] : List<dynamic>.from(json["trophies"]!.map((x) => x)),
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      heatmap: json["heatmap"] == null ? [] : List<dynamic>.from(json["heatmap"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      address: json["address"],
      ageGroup: json["ageGroup"],
      bio: json["bio"],
      county: json["county"],
      parentEmail: json["parentEmail"],
      parentFirstName: json["parentFirstName"],
      parentLastName: json["parentLastName"],
      parentPhone: json["parentPhone"],
      parentRelation: json["parentRelation"],
      playerAge: json["playerAge"],
      playerHeight: json["playerHeight"],
      playerLeg: json["playerLeg"],
      playerPosition: json["playerPosition"],
    );
  }

}
