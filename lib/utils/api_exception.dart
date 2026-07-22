import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return "ApiException: $message (Status Code: $statusCode)";
    }
    return "ApiException: $message";
  }

  static ApiException fromError(dynamic error) {
    if (error is SocketException) {
      return ApiException(message: "No internet connection");
    } else if (error is HttpException) {
      return ApiException(message: "Server error occurred");
    } else if (error is FormatException) {
      return ApiException(message: "Invalid response format");
    } else if (error is Response) {
      final response = error;
      return ApiException(
        message: response.bodyString ?? "Unexpected error occurred",
        statusCode: response.statusCode,
      );
    } else {
      return ApiException(message: "Unexpected error: ${error.toString()}");
    }
  }
}
