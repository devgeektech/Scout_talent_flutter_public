import 'package:flutter/foundation.dart';
import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';
import '../../utils/utils.dart';

class VerificationScreenState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;

VerificationScreenState({required this.apiService, required this.sharedPreferencesManager});


//Otp verification method
otpVerification(dynamic body) async {
  String? currentLang = await getLanguage();
  return await apiService.postApi(endpoint: accountVerification,data: body,);
}

//Otp verification method
  resendOtp(dynamic body) async {
    String? currentLang = await getLanguage();
    return await apiService.postApi(endpoint: resendVerifyAccountOtp,data: body,);
  }

  void saveData(String token, String uid,String email,String avatar) {
    if (kDebugMode) {
      print("🔐 Saving data to SharedPreferences...");
      print("🟦 Token: $token");
      print("🟩 UID: $uid");
      print("🟩 Email: $email");
      print("🟩 Avatar: $avatar");
    }


    sharedPreferencesManager.putString('token', token);
    sharedPreferencesManager.putString('uid', uid);
    sharedPreferencesManager.putString('email', email);
    sharedPreferencesManager.putString('avatar', avatar);
    Utils.accessToken = token;
    Utils.accessToken = uid;
    Utils.avatar = avatar;
    Utils.userProfileImage = avatar;

    // Read back to confirm saved correctly
    final savedToken = sharedPreferencesManager.getString('token');
    Utils.userUid = sharedPreferencesManager.getString('uid')!;
    Utils.userEmail = sharedPreferencesManager.getString('email')!;

    if (kDebugMode) {
      print("✅ Data saved successfully!");
      print("🔍 Saved Token: $savedToken");
      print("🔍 Saved UID: ${Utils.userUid}");
      print("🔍 Saved Email: ${Utils.userEmail}");
      print("🔍 Saved avatar: ${Utils.avatar}");
    }
  }



  String getFCM() {
    return sharedPreferencesManager.getString(AppString.fcmToken) ?? '';
  }
}
