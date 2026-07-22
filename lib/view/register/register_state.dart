import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/string.dart';

class RegisterState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
RegisterState({required this.sharedPreferencesManager,required this.apiService});

String getLanguage() {
  return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
}


String getRole() {
  return sharedPreferencesManager.getString('selectedUserRole') ?? '';
}

}
