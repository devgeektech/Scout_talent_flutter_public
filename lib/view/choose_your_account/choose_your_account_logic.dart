import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/app_assets.dart';

import 'choose_your_account_state.dart';

class ChooseYourAccountLogic extends GetxController {
  final ChooseYourAccountState state;

  ChooseYourAccountLogic({required this.state});

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSavedCredentials();
    });
  }


  List<RoleItem> roles = [
    RoleItem(AssetPath.player, "Player", "Create. Upload. Get discovered."),
    RoleItem(
      AssetPath.search,
      "Club Scout",
      "Analyze players, build connections",
    ),
    RoleItem(
      AssetPath.clubAcademy,
      "Club / Academy",
      "Manage teams, find talents",
    ),
    RoleItem(AssetPath.agent, "Agent", "Connect. Represent. Grow."),
  ];

  RxString selectedRole = ''.obs;
  String selectedLanguage = 'en';

  updateSelectedRole(String value) {
    selectedRole.value = value;
    update();
  }


  String normalizeRole(String selectedUserRole) {
    switch (selectedUserRole) {
      case "Club / Academy":
        return "club";
      case "Club Scout":
        return "scout";
      case "Agent":
        return "agent";
      case "Player":
        return "player";
      default:
        return selectedUserRole;
    }
  }


  Future<void> loadSavedCredentials() async {



    // ------------------------------
    // 1️⃣ Load saved language
    // ------------------------------
    String? langCode = state.getLanguage();
    print("langCode====>$langCode");
    if (langCode.isNotEmpty) {
      selectedLanguage = langCode;
      Get.updateLocale(Locale(langCode));
    } else {
      selectedLanguage = 'en';
      Get.updateLocale(const Locale('en'));
    }
    update(); // notify listeners if using GetX
  }


  void updateLanguage(String langCode) async {
    selectedLanguage = langCode;

    // Update App Language
    Get.updateLocale(Locale(langCode));

    // Save to SharedPreferences
    await state.saveLanguage(langCode);

    update(); // Refresh UI
  }
}

class RoleItem {
  final String imagePath;
  final String role;
  final String roleDescription;

  RoleItem(this.imagePath, this.role, this.roleDescription);
}
