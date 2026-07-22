import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

import '../../utils/string.dart';

class ChooseYourAccountState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
ChooseYourAccountState({required this.sharedPreferencesManager,required this.apiService});


Future<void> saveLanguage(String langCode) async {
  await sharedPreferencesManager.putString(AppString.currentLang, langCode);
  print("🌍 Language saved: $langCode");
}

String getLanguage() {
  return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
}



}
