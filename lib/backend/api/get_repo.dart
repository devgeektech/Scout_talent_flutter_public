

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scouttalent2/utils/utils.dart';
import '../helper/api_helper.dart';
import 'api.dart';

// GET METHOD
/*Note-- The return type depends on what response.data is expected to be.
 If it's complex, you might need to return dynamic.*/

Future<Response?> getData(String endpoint) async {


  debugPrint("END-POINT :: $endpoint");
  try {
    final response = await ApiService.dio.get(endpoint);
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}


Future<Response?> getDataWithHeader(String endpoint ,{bool showToast = true}) async {

  final token = await getAuthToken();
  final lang = await getLanguage();
  Map<String, dynamic> header = {
    "Authorization": token,
    "Accept": "application/json",
    'lang':lang
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("AUTHENTICATION :: $token");
  debugPrint("HEADER :: $header");


  try {
    final response = await ApiService.dio.get(endpoint,options: Options(headers: header,
      validateStatus: (status) => status != null && status < 500,));
    debugPrint("📦 Response: ${response.statusCode} — ${response.data}");
    ApiHelper.handleStatusCode(response,showToast: showToast);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}