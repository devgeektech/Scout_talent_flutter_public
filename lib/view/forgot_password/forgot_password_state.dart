import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

import '../../utils/string.dart';

class ForgotPasswordState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
ForgotPasswordState({required this.apiService, required this.sharedPreferencesManager});


String getLanguage() {
  return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
}

}
