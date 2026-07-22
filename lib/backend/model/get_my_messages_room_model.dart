class GetMyMessagesRoomModel {
  GetMyMessagesRoomModel({
     this.responseCode,
     this.responseMessage,
     this.data,
  });

  final num? responseCode;
  final String? responseMessage;
  final List<MessageRoomData>? data;

  factory GetMyMessagesRoomModel.fromJson(Map<String, dynamic> json){
    return GetMyMessagesRoomModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<MessageRoomData>.from(json["data"]!.map((x) => MessageRoomData.fromJson(x))),
    );
  }

}

class MessageRoomData {
  MessageRoomData({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    required this.users,
  });

  final String? id;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Message> messages;
  final List<User> users;

  factory MessageRoomData.fromJson(Map<String, dynamic> json){
    return MessageRoomData(
      id: json["_id"],
      createdBy: json["createdBy"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
      users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    );
  }

}

class Message {
  Message({
    required this.id,
    required this.message,
    required this.room,
    required this.sender,
    required this.isSeen,
    required this.receiver,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? message;
  final String? room;
  final Receiver? sender;
  final bool? isSeen;
  final Receiver? receiver;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      id: json["_id"],
      message: json["message"],
      room: json["room"],
      sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
      isSeen: json["isSeen"],
      receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}

class Receiver {
  Receiver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.password,
    required this.avatar,
    required this.phone,
    required this.dob,
    required this.playerAge,
    required this.playerHeight,
    required this.playerLeg,
    required this.playerPosition,
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
    required this.schoolName,
    required this.schoolAddress,
    required this.schoolPhone,
    required this.currentTeam,
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
    required this.consistency,
    required this.contractEnd,
    required this.contractStart,
    required this.country,
    required this.countryCode,
    required this.experienceLevel,
    required this.nationality,
    required this.playingStyle,
    required this.roNationality,
    required this.secondaryPosition,
    required this.technicalAttributes,
    required this.weight,
    required this.isSubscribeNewsLetter,
    required this.freePlanStartAt,
    required this.freePlanEndAt,
    required this.address,
    required this.ageGroup,
    required this.bio,
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
  final String? playerAge;
  final String? playerHeight;
  final String? playerLeg;
  final String? playerPosition;
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
  final String? schoolName;
  final String? schoolAddress;
  final String? schoolPhone;
  final String? currentTeam;
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
  final num? v;
  final String? consistency;
  final DateTime? contractEnd;
  final DateTime? contractStart;
  final String? country;
  final String? countryCode;
  final String? experienceLevel;
  final String? nationality;
  final List<String> playingStyle;
  final String? roNationality;
  final List<String> secondaryPosition;
  final List<String> technicalAttributes;
  final num? weight;
  final bool? isSubscribeNewsLetter;
  final DateTime? freePlanStartAt;
  final DateTime? freePlanEndAt;
  final String? address;
  final String? ageGroup;
  final String? bio;
  final dynamic fcmToken;

  factory Receiver.fromJson(Map<String, dynamic> json){
    return Receiver(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      password: json["password"],
      avatar: json["avatar"],
      phone: json["phone"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      playerAge: json["playerAge"],
      playerHeight: json["playerHeight"],
      playerLeg: json["playerLeg"],
      playerPosition: json["playerPosition"],
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
      schoolName: json["schoolName"],
      schoolAddress: json["schoolAddress"],
      schoolPhone: json["schoolPhone"],
      currentTeam: json["currentTeam"],
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
      consistency: json["consistency"],
      contractEnd: DateTime.tryParse(json["contractEnd"] ?? ""),
      contractStart: DateTime.tryParse(json["contractStart"] ?? ""),
      country: json["country"],
      countryCode: json["countryCode"],
      experienceLevel: json["experienceLevel"],
      nationality: json["nationality"],
      playingStyle: json["playingStyle"] == null ? [] : List<String>.from(json["playingStyle"]!.map((x) => x)),
      roNationality: json["roNationality"],
      secondaryPosition: json["secondaryPosition"] == null ? [] : List<String>.from(json["secondaryPosition"]!.map((x) => x)),
      technicalAttributes: json["technicalAttributes"] == null ? [] : List<String>.from(json["technicalAttributes"]!.map((x) => x)),
      weight: json["weight"],
      isSubscribeNewsLetter: json["isSubscribeNewsLetter"],
      freePlanStartAt: DateTime.tryParse(json["freePlanStartAt"] ?? ""),
      freePlanEndAt: DateTime.tryParse(json["freePlanEndAt"] ?? ""),
      address: json["address"],
      ageGroup: json["ageGroup"],
      bio: json["bio"],
      fcmToken: json["fcmToken"],
    );
  }

}

class User {
  User({
    required this.id,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  final String? id;
  final String? avatar;
  final String? firstName;
  final String? lastName;
  final String? role;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["_id"],
      avatar: json["avatar"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
    );
  }

}
