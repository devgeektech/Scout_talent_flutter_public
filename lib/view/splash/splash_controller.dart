import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';
import 'package:scouttalent2/utils/string.dart';
import 'package:scouttalent2/utils/utils.dart';
import '../../backend/helper/app_router.dart';
import '../../backend/model/ProfileResponseModel.dart';
import '../../utils/constants.dart';
import 'splash_parser.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final SplashParser parser;
  SplashController({required this.parser});


  @override
  Future<void> onInit() async {
    await loadAllUserData();
    Timer(const Duration(seconds: 3), () {
      if(parser.haveLoggedIn()){
        handleUserFlow();
      }else{
        Get.offAllNamed(AppRouter.getChooseYourAccount());
      }
    });
    super.onInit();

  }



  Future<void> handleUserFlow() async {
    try {
      final profile = await getUserProfile(); // API call

      if (profile == null) {
        Get.offAllNamed(AppRouter.getChooseYourAccount());
        return;
      }


      bool isFree = profile.data?.isFree ?? false;
      bool hasSubscription = profile.data?.hasSubscription ?? false;
      num playerLimit = profile.data?.playerLimit ?? 0;
      bool isUnlimited = profile.data?.isUnlimited??false;
      String subscriptionStatus = profile.data?.subscriptionStatus?? "";

      if (kDebugMode) {
        print("isFree: $isFree | hasSubscription: $hasSubscription");
        print("Player limit is >>${playerLimit}");
        print("isUnlimited >>${isUnlimited}");
      }

      await parser.sharedPreferencesManager
          .putInt(AppString.playerLimit, playerLimit.toInt());
      await parser.sharedPreferencesManager
          .putBool("isUnlimited", isUnlimited);


      //if (hasSubscription) {
      if (subscriptionStatus != Constants.subscriptionExpired) {
        // User can access home
        Get.offAllNamed(AppRouter.getDashboardRoute());
      } else {
        // User must buy subscription
        Get.offAllNamed(AppRouter.getSubscriptionViewRoute());
      }

    } catch (error) {
      print("error-->$error");
      if (error.toString().contains("UNAUTHORIZED")) {
        Get.offAllNamed(AppRouter.getChooseYourAccount());
      } else {
        Get.offAllNamed(AppRouter.getChooseYourAccount());
      }
    }
  }
  Future<ProfileResModel?> getUserProfile() async {
    try {
      final response = await parser.apiService.getApiWithHeader("$getProfile/${Utils.userUid}");
      print("response.statusCode---->${response?.statusCode}");
      if (response != null && response.statusCode == 200) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        // Parse into ProfileResModel
        final profile = ProfileResModel.fromJson(data);
        await parser.isFreeAccount(profile.data?.isFree??false);
        await parser.hasSubscription(profile.data?.hasSubscription??false);
        await parser.saveUserAvatar(profile.data?.avatar ?? '');
        await parser.subscriptionStatus(profile.data?.subscriptionStatus ?? '');
        if (kDebugMode) {
          print("isFree---->${profile.data?.isFree}");
        }
        if (kDebugMode) {
          print("hasSubscription---->${profile.data?.hasSubscription}");
          print("subscriptionStatus---->${profile.data?.subscriptionStatus}");
        }
        return profile;
      }

      //  Handle unauthorized / invalid token
      if (response?.statusCode == 401 || response?.statusCode == 403) {
        throw Exception("UNAUTHORIZED");
      }

      return null;
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      rethrow;
    }
  }


}
