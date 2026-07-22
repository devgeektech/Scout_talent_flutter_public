import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:scouttalent2/backend/api/patch_repo.dart';
import 'package:scouttalent2/backend/api/post_repos.dart';
import 'package:scouttalent2/backend/api/put_repo.dart';
import '../../utils/utils.dart' as parser;
import 'delete_repo.dart';
import 'get_repo.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
class ApiService extends GetxService {
  final String appBaseUrl;
  static const String connectionIssue = 'Connection failed!';
  final int timeoutInSeconds = 120;
  static late final Dio dio;

  ApiService({required this.appBaseUrl}) {
    dio = Dio(BaseOptions(
      baseUrl: appBaseUrl,
      connectTimeout: Duration(seconds: timeoutInSeconds),
      receiveTimeout: Duration(seconds: timeoutInSeconds),
    ));

    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("📡 FINAL URL → ${options.baseUrl}${options.path}");
          print("📦 BODY → ${options.data}");
          return handler.next(options);
        },
      ),
    );
  }



  // TODO :: POST METHOD
  Future<Response?> postApi({
    String? endpoint,
    required Map<String, dynamic> data,
  }) async{
    final language = await parser.getLanguage();
    return postData(
      endpoint ?? "",
      data,
      lang: language,
    );
  }

  Future<Response?> postApiWithoutBody(String endpoint, String authToken) => postDataWithoutBody(endpoint, authToken);

  Future<Response?> postApiWithBody(String endpoint, {required Map<String, dynamic> body}) async{
    final language = await parser.getLanguage();
    final token = await parser.getAuthToken();
    return postDataWithBody(
      endpoint,
       token,
      body: body,
      lang: language,
    );
  }


  // TODO :: GET METHOD
  Future<Response?> getApi(String endpoint) => getData(endpoint);

  Future<Response?> getApiWithHeader(String? endpoint, {bool showToast = true} )async {
    return getDataWithHeader(endpoint??"",showToast: showToast);
  }



  // TODO :: DELETE METHOD
  Future<Response?> deleteApi(String endpoint, {required data}) => deleteData(endpoint, data);

  Future<Response?> deleteApiWithoutBody(String endpoint)async {
    final lang = await parser.getLanguage();
    final token = await parser.getAuthToken();
    return deleteDataWithoutBody(endpoint, token,lang: lang);
  }


  // TODO :: PUT METHOD
  Future<Response?> putApi(String endpoint, {required data})async {
    final lang = await parser.getLanguage();
    final token = await parser.getAuthToken();
    return putData(endpoint, data,lang: lang,token: token);
  }

  Future<Response?> putApiWithoutBody(String endpoint,)async {
    final lang = await parser.getLanguage();
    final token = await parser.getAuthToken();
    return putDataNoBody(endpoint, lang: lang,token: token);
  }

  Future<Response?> putDataHeaders(String endpoint, {required Map<String, dynamic> data,}) async {

    final lang = await parser.getLanguage();
    final token = await parser.getAuthToken();

    return putDataWithHeaders(
      endpoint,
      data,
      lang: lang,
      token: token,
    );
  }

  Future<Response?> patchDataHeaders(String endpoint, {required Map<String, dynamic> data,}) async {

    final lang = await parser.getLanguage();
    final token = await parser.getAuthToken();

    return patchDataWithHeaders(
      endpoint,
      data,
      lang: lang,
      token: token,
    );
  }


  Future<Response?> patchData(String endpoint,) async {


    return patchApiWithoutBody(
      endpoint,
    );
  }


  Future<Response?> putApiWithImage(String endpoint, String? file, String authToken, {required data}) =>
      putDataWithImage(endpoint, data, file, authToken);

  Future<http.StreamedResponse?> postMultipartApiHttp(String endpoint, {required Map<String, dynamic> fields, required String fileKey, required String filePath}) async {
    try {
      // Build Uri
      Uri uri = Uri.parse('$appBaseUrl$endpoint');

      // Create Multipart Request
      var request = http.MultipartRequest('POST', uri);

      // Add fields
      request.fields.addAll(fields.map((key, value) => MapEntry(key, value.toString())));

      // Add file
      var file = await http.MultipartFile.fromPath(
        fileKey,
        filePath,
        filename: path.basename(filePath),
      );
      request.files.add(file);

      if (kDebugMode) {
        print("📤 Sending multipart request to $uri");
      }
      if (kDebugMode) {
        print("📦 Fields: ${request.fields}");
      }
      if (kDebugMode) {
        print("🖼 File: $filePath");
      }

      // Send request
      var response = await request.send();

      print("📥 RESPONSE STATUS: ${response.statusCode}");

      // Read response body
      final responseBody = await response.stream.bytesToString();
      if (kDebugMode) {
        print("📥 RESPONSE BODY: $responseBody");
      }

      return response;
    } catch (e, s) {
      if (kDebugMode) {
        print("❌ Multipart Upload Error: $e");
      }
      if (kDebugMode) {
        print("📌 StackTrace: $s");
      }
      return null;
    }
  }

  Future<Response?> postMultipartApi(String endpoint, {required Map<String, dynamic> fields, required Map<String, File> files}) async {
    final language = await parser.getLanguage();
    final token = await parser.getAuthToken();

    return postMultipartData(
      endpoint,
      fields: fields,
      files: files,
      lang: language,
      token: token,
    );
  }

  Future<Response?> putMultipartApi(String endpoint, {required Map<String, dynamic> fields, required Map<String, File> files,}) async {
    final language = await parser.getLanguage();
    final token = await parser.getAuthToken();

    print('FIELDS>>>>>${fields}');

    return putMultipartData(
      endpoint,
      fields: fields,
      files: files,
      lang: language,
      token: token,
    );
  }



// TODO :: PATCH METHOD
  Future<Response?> patchApi(String endpoint, {required data})async {
    return patchData(endpoint,);
  }


  Future<Response?> patchApiWithoutBody(String endpoint,)async {
    final lang = await parser.getLanguage();
    final token = await parser.getAuthToken();
    print("LANG SEND???${lang}");
    return patchDataNoBody(endpoint, lang: lang,token: token);
  }






}