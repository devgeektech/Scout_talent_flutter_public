class GetAllPlayerPlans {
  int? responseCode;
  String? responseMessage;
  List<PlayerPlanData>? data;
  int? totalRecord;

  GetAllPlayerPlans(
      {this.responseCode, this.responseMessage, this.data, this.totalRecord});

  GetAllPlayerPlans.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['data'] != null) {
      data = <PlayerPlanData>[];
      json['data'].forEach((v) {
        data!.add(PlayerPlanData.fromJson(v));
      });
    }
    totalRecord = json['totalRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalRecord'] = totalRecord;
    return data;
  }
}

class PlayerPlanData {
  String? sId;
  String? title;
  String? description;
  String? type;
  double? price;
  int? discount;
  bool? recommendedPlan;
  int? videos;
  String? priceId;
  List<String>? features;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? couponDiscount;
  double? finalPrice;
  String? roTitle;
  List<String>? roFeatures;
  String? stripeProductId;
  String? iosProductId;
  int? maxUsers;
  List<String>? restrictions;
  List<String>? roRestrictions;

  PlayerPlanData(
      {this.sId,
        this.title,
        this.description,
        this.type,
        this.price,
        this.discount,
        this.recommendedPlan,
        this.videos,
        this.priceId,
        this.features,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.couponDiscount,
        this.finalPrice,
        this.roTitle,
        this.roFeatures,
        this.stripeProductId,
        this.iosProductId,
        this.maxUsers,
        this.restrictions,
        this.roRestrictions,
      });

  PlayerPlanData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    discount = json['discount'];
    recommendedPlan = json['recommendedPlan'];
    videos = json['videos'];
    priceId = json['priceId'];
    features = (json['features'] as List?)?.map((e) => e.toString()).toList() ?? [];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    couponDiscount = json['couponDiscount'];
    price = (json['price'] as num?)?.toDouble();
    finalPrice = (json['finalPrice'] as num?)?.toDouble();
    roTitle = json['roTitle'];
    roFeatures = (json['roFeatures'] as List?)?.map((e) => e.toString()).toList() ?? [];
    stripeProductId = json['stripeProductId'];
    iosProductId = json['iosProductId'];
    maxUsers = json['maxUsers'];
    restrictions = (json['restrictions'] as List?)?.map((e) => e.toString()).toList() ?? [];
    roRestrictions = (json['roRestrictions'] as List?)?.map((e) => e.toString()).toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['price'] = price;
    data['discount'] = discount;
    data['recommendedPlan'] = recommendedPlan;
    data['videos'] = videos;
    data['priceId'] = priceId;
    data['features'] = features;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['couponDiscount'] = couponDiscount;
    data['finalPrice'] = finalPrice;
    data['roTitle'] = roTitle;
    data['stripeProductId'] = stripeProductId;
    data['iosProductId'] = iosProductId;
    data['maxUsers'] = maxUsers;
    data['restrictions'] = restrictions;
    data['roRestrictions'] = roRestrictions;
    return data;
  }
}
