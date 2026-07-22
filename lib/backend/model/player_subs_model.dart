class PlayerSubsModel {
  PlayerSubsModel({this.responseCode, this.responseMessage, this.data});

  final num? responseCode;
  final String? responseMessage;
  final Data? data;

  factory PlayerSubsModel.fromJson(Map<String, dynamic> json) {
    return PlayerSubsModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.id,
    required this.plan,
    required this.user,
    required this.status,
    required this.subscribeId,
    required this.paymentMethod,
    required this.paymentType,
    required this.expiryDate,
    required this.subscribeDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.subscriptionStatus,
    required this.restoreSubscription,
  });

  final String? id;
  final SubscriptionPlan? plan;
  final User? user;
  final String? status;
  final String? subscribeId;
  final String? paymentMethod;
  final String? paymentType;
  final DateTime? expiryDate;
  final DateTime? subscribeDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final String? subscriptionStatus;
  final bool? restoreSubscription;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["_id"],
      plan: json["plan"] == null ? null : SubscriptionPlan.fromJson(json["plan"]),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      status: json["status"],
      subscribeId: json["subscribeId"],
      paymentMethod: json["paymentMethod"],
      paymentType: json["paymentType"],
      expiryDate: DateTime.tryParse(json["expiryDate"] ?? ""),
      subscribeDate: DateTime.tryParse(json["subscribeDate"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      subscriptionStatus: json["subscriptionStatus"],
      restoreSubscription: json["restoreSubscription"],
    );
  }
}

class SubscriptionPlan {
  SubscriptionPlan({
    required this.id,
    required this.title,
    required this.roTitle,
    required this.description,
    required this.type,
    required this.price,
    required this.discount,
    required this.recommendedPlan,
    required this.videos,
    required this.priceId,
    required this.features,
    required this.roFeatures,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.couponDiscount,
    required this.finalPrice,
    required this.iosProductId,
  });

  final String? id;
  final String? title;
  final String? roTitle;
  final String? description;
  final String? type;
  final num? price;
  final num? discount;
  final bool? recommendedPlan;
  final int? videos;
  final String? priceId;
  final List<String> features;
  final List<String> roFeatures;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final num? couponDiscount;
  final num? finalPrice;
  String? iosProductId;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json["_id"],
      title: json["title"],
      roTitle: json["roTitle"],
      description: json["description"],
      type: json["type"],
      price: json["price"],
      discount: json["discount"],
      recommendedPlan: json["recommendedPlan"],
      videos: json["videos"],
      priceId: json["priceId"],
      features: json["features"] == null
          ? []
          : List<String>.from(json["features"]!.map((x) => x)),
      roFeatures: json["roFeatures"] == null
          ? []
          : List<String>.from(json["roFeatures"]!.map((x) => x)),
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      couponDiscount: json["couponDiscount"],
      finalPrice: json["finalPrice"],
      iosProductId: json["iosProductId"],
    );
  }
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      avatar: json["avatar"],
    );
  }
}
