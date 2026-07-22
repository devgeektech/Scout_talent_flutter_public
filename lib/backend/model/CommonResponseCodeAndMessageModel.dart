class ResponseCodeAndMessageModel {
  ResponseCodeAndMessageModel({
     this.responseCode,
     this.responseMessage,
  });

  final num? responseCode;
  final String? responseMessage;

  factory ResponseCodeAndMessageModel.fromJson(Map<String, dynamic> json){
    return ResponseCodeAndMessageModel(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
    );
  }

}
