class OTPResponseModel {
  final int? responseCode;
  final String? responseMessage;

  OTPResponseModel({
    this.responseCode,
    this.responseMessage,
  });

  factory OTPResponseModel.fromJson(Map<String, dynamic> json) {
    return OTPResponseModel(
      responseCode: json['responseCode'],
      responseMessage: json['responseMessage'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "responseCode": responseCode,
      "responseMessage": responseMessage,
    };
  }
}