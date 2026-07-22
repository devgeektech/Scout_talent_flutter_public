 import 'package:flutter/foundation.dart';
import 'package:scouttalent2/utils/string.dart';
import 'package:scouttalent2/utils/utils.dart';

import '../../../backend/helper/shared_pref.dart';
import '../../backend/api/api.dart';
import '../../utils/api_endpoint.dart';

/// Handles login-related operations like saving user data and making API calls.
class LoginParser {

  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  /// Creates an instance of [LoginParser].
  LoginParser({required this.sharedPreferencesManager, required this.apiService});

  /// Saves the authentication token and user ID to shared preferences.
  void saveData(String token, String uid, String avatar,
      bool hasSubscription,num playerLimit,bool isUnlimited,
      String subscriptionStatus
      ) {
    if (kDebugMode) {
      print("🔐 Saving data to SharedPreferences...");
    }
    if (kDebugMode) {
      print("🟦 Token: $token");
    }
    if (kDebugMode) {
      print("🟩 UID: $uid");
    }

    sharedPreferencesManager.putString('token', token);
    sharedPreferencesManager.putString('uid', uid);
    sharedPreferencesManager.putString('avatar', avatar);
    sharedPreferencesManager.putBool("hasSubscription", hasSubscription);
    sharedPreferencesManager.putInt(AppString.playerLimit, playerLimit.toInt());
    sharedPreferencesManager.putBool("isUnlimited", isUnlimited);
    sharedPreferencesManager.putString("subscriptionStatus", subscriptionStatus);

    // Read back to confirm saved correctly
    Utils.accessToken = sharedPreferencesManager.getString('token')??"";
    Utils.userUid = sharedPreferencesManager.getString('uid')??"";
    Utils.userProfileImage = sharedPreferencesManager.getString('avatar')!;
    bool hasSubscriptionVal = sharedPreferencesManager.getBool('hasSubscription');
    int playerLimitVal = sharedPreferencesManager.getInt(AppString.playerLimit)??0;
    bool isUnlimitedVal = sharedPreferencesManager.getBool("isUnlimited");
    Utils.subscriptionStatue = sharedPreferencesManager.getString('subscriptionStatus')!;

    if (kDebugMode) {
      print("✅ Data saved successfully!");
    }
    if (kDebugMode) {
      print("🔍 Saved Token: ${Utils.accessToken}");
    }
    print("🔍 Saved UID: ${Utils.userUid}");
    print("🔍 Utils savedAvatar: ${Utils.userProfileImage}");
    print("🔍 hasSubscriptionVal: ${hasSubscriptionVal}");
    print("🔍 playerLimit: ${playerLimitVal}");
    print("🔍 isUnlimitedVal: ${isUnlimitedVal}");
    print("🔍 subscriptionStatus: ${subscriptionStatus}");
  }

  Future<void> saveLanguage(String langCode) async {
    await sharedPreferencesManager.putString(AppString.currentLang, langCode);
    if (kDebugMode) {
      print("🌍 Language saved: $langCode");
    }
  }
  /// Logs in a user via email by making a POST request.
   loginWithEmail(dynamic body,{String? lang}) async {
    return await apiService.postApi(endpoint: login,data: body, );
  }

  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
  }



  String getFCM() {
    return sharedPreferencesManager.getString(AppString.fcmToken) ?? '';
  }

}
