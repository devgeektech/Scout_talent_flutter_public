import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';

class SubscriptionPricingState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
SubscriptionPricingState({required this.sharedPreferencesManager, required this.apiService});

String getAllPlansUrl() {
  String typeParam = Platform.isIOS ? "&type=ios" : "";
  switch (Utils.userRole) {
    case "player":
      return getAllPlayerPlansUrl + typeParam;
    case "agent":
      return getAllAgentPlansUrl + typeParam;
    case "club":
      return getAllClubAcademyPlansUrl + typeParam;
    case "scout":
      return getAllScoutPlansUrl + typeParam;
    default:
      throw Exception("Invalid user role: ${Utils.userRole}");
  }
}

getAllPlayerPlansApi() async {
  String? currentLang = await getLanguage();
  return await apiService.getApi(getAllPlansUrl());
}

String getSubscriptionUrl() {
  switch (Utils.userRole) {
    case "player":
      return createPlayerSubscription;
    case "agent":
      return createAgentSubscription;
    case "club":
      return createClubAcademySubscription;
    case "scout":
      return createScoutSubscription;
    default:
      throw Exception("Invalid user role: ${Utils.userRole}");
  }
}
createSubscription(Map<String, dynamic> body, String endPoint) async {
  return await apiService.postApiWithBody(endPoint,body: body);
}
createIosSubscription(Map<String, dynamic> body) async {
  print("API GOT CALLED-------------");
  return await apiService.postApiWithBody("payment/subscription",body: body);
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
Future<bool> getRestoreSubscription() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final value = prefs.getBool("restoreSubscription") ?? false;
  if (kDebugMode) {
    print("Fetched restoreSubscription: $value");
  }
  return value;
}
}
