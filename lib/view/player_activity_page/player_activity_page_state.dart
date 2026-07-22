import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';

import '../../utils/string.dart';

class PlayerActivityPageState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
PlayerActivityPageState({required this.apiService,required this.sharedPreferencesManager});

int limits = 10;
activitiesList(int page) async {
  return await apiService.getApiWithHeader("$playerActivities?limit=$limits&page=$page");
}

String getLanguage() {
  return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
}
}
