

import '../../../backend/helper/shared_pref.dart';
import '../../backend/api/api.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';

class HomeScreenParser {

  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HomeScreenParser({required this.sharedPreferencesManager, required this.apiService});

  Future<dynamic> fetchingTrendingVideos(int page, int limit) async {
    return await apiService.getApiWithHeader(
      "videos/getAllTrendingVideos?page=$page&limit=$limit",
    );
  }

  fetchingLogos() async{
    return await apiService.getApiWithHeader("partners-logo");
  }

  int limits = 10;
  fetchNotificationList(int page, String type) async {
    return await apiService.getApiWithHeader("$notifications?limit=$limits&page=$page&type=$type");
  }

  updateLang()async{
    return await apiService.patchApiWithoutBody('settings/updateLanguage');
  }


  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? 'en';
  }

  String getUid() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

}
