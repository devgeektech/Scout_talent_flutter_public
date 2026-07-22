import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../utils/toast.dart';

class ApiHelper {
  /// Handles HTTP status codes and optionally shows toast messages.
  static void handleStatusCode(
      Response response, {
        bool showToast = true,
      }) {
    final int? statusCode = response.statusCode;
    final dynamic responseData = response.data;

    void showError(String message) {
      if (showToast) errorToast(message);
    }

    switch (statusCode) {
      case 200:
      case 201:
      // Success, nothing to do
        break;

      case 400:
        debugPrint("Bad Request: $responseData");
        showError('Bad request. Please try again.');
        break;

      case 401:
        debugPrint("Unauthorized: $responseData");
        //showError('Session expired. Please login again.');
        break;

      case 403:
        debugPrint("Forbidden: $responseData");
        //showError('You don\'t have permission to access this resource.');
        break;

      case 404:
        debugPrint("Not Found: $responseData");
        String message = "Something went wrong";
        if (responseData != null) {
          try {
            if (responseData is String) {
              final Map<String, dynamic> decoded = jsonDecode(responseData);
              message = decoded["responseMessage"] ?? message;
            } else if (responseData is Map<String, dynamic>) {
              message = responseData["responseMessage"] ?? message;
            }
          } catch (e) {
            debugPrint("JSON decode failed: $e");
          }
        }
        showError(message);
        break;

      case 422:
        debugPrint("Unprocessable Entity: $responseData");
        showError(response.statusMessage ?? "Unprocessable entity");
        break;

      case 500:
      case 502:
      case 503:
      case 504:
        debugPrint("Server Error ($statusCode): $responseData");
        showError('Oops! Something went wrong on our end.');
        break;

      default:
        debugPrint("Unhandled status: $statusCode - $responseData");
        showError('Unexpected error occurred.');
    }
  }

  /// Handles Dio or general errors and optionally shows toast messages.
  static void handleError(
      Object error, {
        bool showToast = true,
      }) {
    String errorDescription = '';

    void showError(String message) {
      if (showToast) errorToast(message);
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          errorDescription = 'Connection timeout with the server';
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = 'Send timeout in connection with the server';
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = 'Receive timeout in connection with the server';
          break;
        case DioExceptionType.badResponse:
          final responseData = error.response?.data;

          if (responseData is Map<String, dynamic> &&
              responseData['responseMessage'] != null) {
            errorDescription = responseData['responseMessage'];
          } else if (responseData is String) {
            try {
              final decoded = jsonDecode(responseData);
              errorDescription =
                  decoded['responseMessage'] ?? 'Something went wrong';
            } catch (_) {
              errorDescription = 'Something went wrong';
            }
          } else {
            errorDescription = 'Something went wrong';
          }
          break;

        case DioExceptionType.cancel:
          errorDescription = 'Request to the server was cancelled';
          break;
        case DioExceptionType.unknown:
        default:
          errorDescription = 'Unexpected error occurred: ${error.message}';
          break;
      }
    } else {
      errorDescription = 'Unexpected error: $error';
    }

    debugPrint('Error: $errorDescription');
    showError(errorDescription);
  }
}
