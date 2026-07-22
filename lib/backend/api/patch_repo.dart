
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../helper/api_helper.dart';
import 'api.dart';

Future<Response?> patchData(String endpoint, Map<String, dynamic> data, {required String lang, required String token}) async {
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



Future<Response?> patchDataNoBody(String endpoint, {required String lang, required String token}) async {
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
          "Authorization": token, // recommended format
        },
      ),
    );

    print("Patch Response>>>>${response.data}");

    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}