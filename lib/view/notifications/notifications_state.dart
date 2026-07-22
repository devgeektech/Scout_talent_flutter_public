import 'package:scouttalent2/utils/api_endpoint.dart';

import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';
import '../../utils/string.dart';

class NotificationsState {

  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;

  int limits = 10;

  NotificationsState({required this.apiService,required this.sharedPreferencesManager});

  fetchNotificationList(int page, String type) async {
    return await apiService.getApiWithHeader("$notifications?limit=$limits&page=$page&type=$type");
  }

  markAllRead() async {
    return await apiService.putApiWithoutBody("$notifications/markAllAsRead");
  }
  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
  }
}
