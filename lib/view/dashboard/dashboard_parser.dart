import '../../../backend/helper/shared_pref.dart';
import '../../backend/api/api.dart';
import '../../utils/string.dart';

class DashboardParser {


  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  DashboardParser({required this.sharedPreferencesManager, required this.apiService});


  String getProfileUrl() {
    return sharedPreferencesManager.getString('profile_url') ?? "";
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? '';
  }
  String getFCM() {
    return sharedPreferencesManager.getString(AppString.fcmToken) ?? '';
  }
}
