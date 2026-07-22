import 'dart:io';

import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';

import '../../utils/string.dart';
import '../../utils/utils.dart';

class AddPlayerScreenState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
AddPlayerScreenState({required this.sharedPreferencesManager, required this.apiService});


Future<dynamic> addPlayer(
    {required Map<String, dynamic> fields,
      required Map<String, File> files,}) async {
  final endpoint = await getAddPlayerEndpoint();
  return await apiService.postMultipartApi(
    endpoint,
    fields: fields,
    files: files,
  );
}

getPlayerDetailById({String? playerId}) async {
  final endpoint = await getAddPlayerEndpoint();
  return await apiService.getApiWithHeader("$endpoint/byId/$playerId");
}

Future<dynamic> editPlayer(
    {required Map<String, dynamic> fields,
      required Map<String, File> files,String? playerId}) async {
  final endpoint = await getAddPlayerEndpoint();
  return await apiService.putMultipartApi(
    "$endpoint/$playerId",
    fields: fields,
    files: files,
  );
}
String getLanguage() {
  return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
}
}
