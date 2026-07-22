class SubscriptionAllTransModel {
  int? responseCode;
  String? responseMessage;
  List<Data>? data;
  int? totalRecord;

  SubscriptionAllTransModel(
      {this.responseCode, this.responseMessage, this.data, this.totalRecord});

  SubscriptionAllTransModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  String? plan;
  String? user;
  String? status;
  CardDetails? cardDetails;
  String? hostedInvoiceUrl;
  String? invoicePdf;
  String? subscribeId;
  String? paymentMethod;
  String? expiryDate;
  String? subscribeDate;
  String? createdAt;
  String? updatedAt;
  dynamic amount;
  int? iV;
  PlanDetail? planDetail;

  Data(
      {this.sId,
        this.plan,
        this.user,
        this.status,
        this.cardDetails,
        this.hostedInvoiceUrl,
        this.invoicePdf,
        this.subscribeId,
        this.paymentMethod,
        this.expiryDate,
        this.subscribeDate,
        this.createdAt,
        this.updatedAt,
        this.amount,
        this.iV,
        this.planDetail});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    plan = json['plan'];
    user = json['user'];
    status = json['status'];
    cardDetails = json['cardDetails'] != null
        ? CardDetails.fromJson(json['cardDetails'])
        : null;
    hostedInvoiceUrl = json['hosted_invoice_url'];
    invoicePdf = json['invoice_pdf'];
    subscribeId = json['subscribeId'];
    paymentMethod = json['paymentMethod'];
    expiryDate = json['expiryDate'];
    subscribeDate = json['subscribeDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    amount = json['amount'];
    iV = json['__v'];
    planDetail = json['planDetail'] != null
        ? PlanDetail.fromJson(json['planDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['plan'] = plan;
    data['user'] = user;
    data['status'] = status;
    if (cardDetails != null) {
      data['cardDetails'] = cardDetails!.toJson();
    }
    data['hosted_invoice_url'] = hostedInvoiceUrl;
    data['invoice_pdf'] = invoicePdf;
    data['subscribeId'] = subscribeId;
    data['paymentMethod'] = paymentMethod;
    data['expiryDate'] = expiryDate;
    data['subscribeDate'] = subscribeDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['amount'] = this.amount;
    data['__v'] = iV;
    if (planDetail != null) {
      data['planDetail'] = planDetail!.toJson();
    }
    return data;
  }
}

class CardDetails {
  String? brand;
  String? last4;
  int? expMonth;
  int? expYear;
  String? funding;
  String? country;

  CardDetails(
      {this.brand,
        this.last4,
        this.expMonth,
        this.expYear,
        this.funding,
        this.country});

  CardDetails.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    last4 = json['last4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    funding = json['funding'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    data['last4'] = last4;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['funding'] = funding;
    data['country'] = country;
    return data;
  }
}

class PlanDetail {
  String? sId;
  String? title;
  String? roTitle;
  String? description;
  String? type;
  dynamic price;
  int? discount;
  bool? recommendedPlan;
  int? videos;
  String? priceId;
  List<String>? features;
  List<String>? roFeatures;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PlanDetail(
      {this.sId,
        this.title,
        this.roTitle,
        this.description,
        this.type,
        this.price,
        this.discount,
        this.recommendedPlan,
        this.videos,
        this.priceId,
        this.features,
        this.roFeatures,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PlanDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    roTitle = json['roTitle'];
    description = json['description'];
    type = json['type'];
    price = json['price'];
    discount = json['discount'];
    recommendedPlan = json['recommendedPlan'];
    videos = json['videos'];
    priceId = json['priceId'];
    features = json['features'].cast<String>();
    roFeatures = json['roFeatures'].cast<String>();
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['roTitle'] = roTitle;
    data['description'] = description;
    data['type'] = type;
    data['price'] = price;
    data['discount'] = discount;
    data['recommendedPlan'] = recommendedPlan;
    data['videos'] = videos;
    data['priceId'] = priceId;
    data['features'] = features;
    data['roFeatures'] = roFeatures;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}