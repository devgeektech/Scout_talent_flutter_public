import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../helper/api_helper.dart';
import 'api.dart';

Future<Response?> postData(
  String endpoint,
  Map<String, dynamic> data, {
  String lang = "en",
}) async {

  print("postData lang--->$lang");
  try {
    final response = await ApiService.dio.post(
      endpoint,
      data: data,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "lang": lang, // 👈  ADD LANGUAGE HERE
        },
        validateStatus: (status) => true,
      ),
    );

    if (response.data is String) {
      try {
        response.data = jsonDecode(response.data);
      } catch (e) {
        print("JSON decode error: $e");
      }
    }

    return response;
  } catch (e) {
    print("EE${e.toString()} ");
    ApiHelper.handleError(e);
    return null;
  }
}

Future<Response?> postDataWithBody(
  String endpoint,
  String authToken, {
  required Map<String, dynamic>? body,
  String lang = "en",
}) async {
  Map<String, dynamic> header = {
    "Authorization": authToken,
    "Accept": "application/json",
    "lang": lang,
  };

  debugPrint("ENDPOINT :: $endpoint");
  debugPrint("HEADER :: $header");
  debugPrint("BODY :: $body");

  try {
    final response = await ApiService.dio.post(
      endpoint,
      data: body,
      options: Options(headers: header),
    );

    ApiHelper.handleStatusCode(response);
    return response;
  } on DioException catch (e) {
    // ⬇️ Return server's error response instead of null
    if (e.response != null) {
      debugPrint("❌ SERVER ERROR RESPONSE: ${e.response!.data}");
      return e.response;
    }

    // No server response
    debugPrint("❌ Dio Error: ${e.message}");
    return Response(
      requestOptions: RequestOptions(path: endpoint),
      statusCode: 500,
      data: {"message": "Unexpected error"},
    );
  } catch (e) {
    debugPrint("❌ Unknown Error: $e");
    return Response(
      requestOptions: RequestOptions(path: endpoint),
      statusCode: 500,
      data: {"message": "Unknown error"},
    );
  }
}

Future<Response?> postDataWithoutBody(String endpoint, String authToken) async {
  Map<String, dynamic> header = {
    "Authorization": authToken,
    "Accept": "application/json",
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("HEADER :: $header");
  debugPrint("AUTHENTICATION :: $authToken");

  try {
    final response = await ApiService.dio.post(
      endpoint,
      options: Options(headers: header),
    );
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}

Future<Response?> postUploadImage(
  String endpoint,
  File imageFile, {
  Map<String, dynamic>? extraData,
}) async {
  try {
    // Prepare FormData
    String fileName = basename(imageFile.path); // Extracts the filename
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
      if (extraData != null) ...extraData,
      // Include any additional data in the form
    });

    // Send POST request
    final response = await ApiService.dio.post(endpoint, data: formData);
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}



Future<Response?> postMultipartData(
    String endpoint, {
      required Map<String, dynamic> fields,
      required Map<String, File> files,
      String lang = "en",
      String? token,
    }) async {
  try {
    final Map<String, dynamic> formMap = {};

    // Add normal fields
    formMap.addAll(fields);

    // Add files
    for (var entry in files.entries) {
      final file = entry.value;
      final fileName = basename(file.path);

      formMap[entry.key] = await MultipartFile.fromFile(
        file.path,
        filename: fileName,

      );
    }

    final formData = FormData.fromMap(formMap);

    final response = await ApiService.dio.post(
      endpoint,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "lang": lang,
          if (token != null) "Authorization": token,
        },
      ),
    );

    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}

