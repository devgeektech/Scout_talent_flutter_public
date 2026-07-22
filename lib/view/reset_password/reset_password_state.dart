import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';

class ResetPasswordState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
ResetPasswordState({required this.apiService, required this.sharedPreferencesManager});




String getUid() {
  return sharedPreferencesManager.getString('uid') ?? '';
}

String getToken() {
  return sharedPreferencesManager.getString('token') ?? '';
}


String getLanguage() {
  return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
}
resendOtp(dynamic body) async {
  String? currentLang = getLanguage();
  return await apiService.postApi(endpoint: resendVerifyAccountOtp,data: body,);
}

}
