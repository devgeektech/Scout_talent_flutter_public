class PlayerListModuleModel {
  PlayerListModuleModel({
    this.responseCode,
    this.responseMessage,
    this.data,
    this.totalRecord,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<PlayerListModuleBody>? data;
  final int? totalRecord;

  factory PlayerListModuleModel.fromJson(Map<String, dynamic> json){
    return PlayerListModuleModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<PlayerListModuleBody>.from(json["data"]!.map((x) => PlayerListModuleBody.fromJson(x))),
      totalRecord: json["totalRecord"],
    );
  }

}

class PlayerListModuleBody {
  PlayerListModuleBody({
    required this.id,
    required this.title,
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
    required this.creator,
    required this.name,
  });

  final String? id;
  final String? title;
  final String? video;
  final String? description;
  final String? createdBy;
  final List<dynamic> likes;
  final List<dynamic> shares;
  final List<dynamic> comments;
  final String? privacy;
  final bool? isVerified;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final Creator? creator;
  final String? name;

  factory PlayerListModuleBody.fromJson(Map<String, dynamic> json){
    return PlayerListModuleBody(
      id: json["_id"],
      title: json["title"],
      video: json["video"],
      description: json["description"],
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
      name: json["name"],
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
  final String? parentFirstName;
  final String? parentLastName;
  final String? parentEmail;
  final String? parentPhone;
  final String? parentRelation;
  final String? referredByAnotherUserCode;
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
  final String? country;
  final String? experienceLevel;
  final String? consistency;
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
  final int? v;

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
    );
  }

}
