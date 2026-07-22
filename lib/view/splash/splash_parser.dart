import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';

class SplashParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SplashParser({required this.sharedPreferencesManager, required this.apiService});



  bool haveLoggedIn() {
    final token = sharedPreferencesManager.getString('token') ?? "";
    if (kDebugMode) {
      print("Saved Token in haveLoggedIn(): $token");
    }
    return token.isNotEmpty;
  }


  void savePhoneLange(String lang) {
     sharedPreferencesManager.putString('lang', lang);
  }

  Future<bool> isFreeAccount(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFreeAccount", value);
    print("Saved isFreeAccount: $value");
    return value;
  }

  Future<bool> hasSubscription(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasSubscription", value);
    if (kDebugMode) {
      print("Saved hasSubscription: $value");
    }
    return value;
  }

  Future<void> saveUserAvatar(String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfileImage', avatar);
  }
  Future<void> subscriptionStatus(String subscriptionStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscriptionStatus', subscriptionStatus);
  }
}
