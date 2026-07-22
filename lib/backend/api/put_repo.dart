import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../helper/api_helper.dart';
import 'api.dart';

Future<Response?> putData(
    String endpoint,
    Map<String, dynamic> data, {
      required String lang,
      required String token,
    }) async {
  debugPrint("END-POINT :: $endpoint");
  debugPrint("BODY :: $data");
  debugPrint("LANG :: $lang");
  debugPrint("TOKEN :: $token");

  try {
    final response = await ApiService.dio.put(
      endpoint,
      data: data,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "lang": lang,
          "Authorization": token, // recommended format
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


Future<Response?> putDataNoBody(
    String endpoint, {
      required String lang,
      required String token,
    }) async {
  debugPrint("END-POINT :: $endpoint");
  debugPrint("LANG :: $lang");
  debugPrint("TOKEN :: $token");

  try {
    final response = await ApiService.dio.put(
      endpoint,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "lang": lang,
          "Authorization": token, // recommended format
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

Future<Response?> putDataWithHeaders(
    String endpoint,
    Map<String, dynamic> data,
    {
      required String lang,
      required String token,
    }) async {
  debugPrint("END-POINT :: $endpoint");
  debugPrint("BODY :: $data");
  debugPrint("LANG :: $lang");
  debugPrint("TOKEN :: $token");

  try {
    final response = await ApiService.dio.put(
      endpoint,
      data: data, // ONLY JSON body here
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "lang": lang,   // separate header
          "Authorization": token,    // separate header
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

Future<Response?> patchDataWithHeaders(
    String endpoint,
    Map<String, dynamic> data, {
      required String lang,
      required String token,
    }) async {
  debugPrint("END-POINT :: $endpoint");
  debugPrint("BODY :: $data");
  debugPrint("LANG :: $lang");
  debugPrint("TOKEN :: $token");

  try {
    final response = await ApiService.dio.patch(
      endpoint,
      data: data,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "lang": lang,
          "Authorization": token,
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

Future<Response?> patchDataWithoutBody(
    String endpoint, {
      required String lang,
      required String token,
    }) async {
  debugPrint("END-POINT :: $endpoint");
  debugPrint("LANG :: $lang");
  debugPrint("TOKEN :: $token");

  try {
    final response = await ApiService.dio.patch(
      endpoint,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "lang": lang,
          "Authorization": token,
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



// PUT METHOD(Multipart)
Future<Response?> putDataWithImage(String endpoint, Map<String, dynamic> mapData, String? filePath, String authToken) async {
  Map<String, dynamic> header = {
    "Authorization": authToken,
    "Accept": "application/json",
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("AUTHENTICATION :: $authToken");
  debugPrint("HEADER :: $header");
  debugPrint("BODY :: $mapData");

  try {
    FormData formData;
    if (filePath != null && filePath.isNotEmpty) {
      File file = File(filePath);
      String fileName = basename(file.path);
      formData = FormData.fromMap({
        ...mapData,
        'picture': await MultipartFile.fromFile(filePath, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        ...mapData,
      });
    }

    Response response = await ApiService.dio.put(
      endpoint, data: formData,
      options: Options(headers: header, validateStatus: (status) => status != null && status < 500),
    );
    debugPrint('Data: $response');
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}

//Multiple fields and images
Future<Response?> putMultipartData(
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

    final response = await ApiService.dio.put(
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