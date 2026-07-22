class RecentListModel {
  RecentListModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<RecentListBody>? data;

  factory RecentListModel.fromJson(Map<String, dynamic> json){
    return RecentListModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<RecentListBody>.from(json["data"]!.map((x) => RecentListBody.fromJson(x))),
    );
  }

}

class RecentListBody {
  RecentListBody({
    required this.isSaved,
    required this.isRated,
    required this.isCompared,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.avatar,
  });

  final bool? isSaved;
  final bool? isRated;
  final bool? isCompared;
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? avatar;

  bool isSelectSave = false;
  bool isSelectRate = false;
  bool isAddToCard = false;


  factory RecentListBody.fromJson(Map<String, dynamic> json){
    return RecentListBody(
      isSaved: json["isSaved"],
      isRated: json["isRated"],
      isCompared: json["isCompared"],
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
      email: json["email"],
      avatar: json["avatar"],
    );
  }

}
