import 'package:flutter/foundation.dart';
import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/string.dart';

class SubscriptionSettingState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;
  SubscriptionSettingState({required this.sharedPreferencesManager, required this.apiService});

  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? 'en';
  }


  String? getAuthToken() {
    return sharedPreferencesManager.getString(AppString.authToken);
  }

  String? getUID() {
    return sharedPreferencesManager.getString(AppString.uid);
  }
  Future<bool> isFreeAccount(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFreeAccount", value);
    if (kDebugMode) {
      print("Saved isFreeAccount: $value");
    }
    return value;
  }
  Future<bool> hasSubscription(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasSubscription", value);
    print("Saved hasSubscription: $value");
    return value;
  }

}
