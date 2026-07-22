class LogosModel {
  LogosModel({
    this.responseCode,
    this.responseMessage,
    this.data,
  });

  final int? responseCode;
  final String? responseMessage;
  final List<String>? data;

  factory LogosModel.fromJson(Map<String, dynamic> json){
    return LogosModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
    );
  }

}
