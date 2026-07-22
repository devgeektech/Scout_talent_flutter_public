
import 'package:flutter/foundation.dart';

import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/constants.dart';
import '../../utils/string.dart';
import '../../utils/utils.dart';

class PlayerParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PlayerParser({required this.sharedPreferencesManager, required this.apiService});
  updateLang()async{
    return await apiService.patchApiWithoutBody('settings/updateLanguage');
  }

  // getPlayerDetailById({String? playerId}) async {
  //   final endpoint = await getAddPlayerEndpoint();
  //   return await apiService.getApiWithHeader("$endpoint/byId/$playerId");
  // }
  getPlayerDetailById({String? playerId}) async {
    final endpoint = await getPlayerReportEndpoint();
    final role = await Utils().getUserType();

    String url;

    if (role == Constants.userRolePlayer) {
      url = "$endpoint/$playerId";
    } else {
      url = "$endpoint/byId/$playerId";
    }

    return await apiService.getApiWithHeader(url);
  }


  saveHeatmap(dynamic body) async {
    final endpoint = await getHeatmapEndpoint();
    return await apiService.postApi(endpoint: "$endpoint/heatmap",data: body,);
  }

  sendProfileLink(dynamic body) async {
    final endpoint = await getAddPlayerEndpoint();
    return await apiService.postApi(endpoint: "$endpoint/send-profile-link",data: body,);
  }

  Future<void> saveLanguage(String langCode) async {
    await sharedPreferencesManager.putString(AppString.currentLang, langCode);
    if (kDebugMode) {
      print("🌍 Language saved: $langCode");
    }
  }

  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
  }

}
