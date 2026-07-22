import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/model/player_subs_model.dart';
import '../../utils/constants.dart';
import 'subscription_state.dart';

class SubscriptionLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final SubscriptionState state;

  SubscriptionLogic({required this.state});

  late TabController tabController;
  bool isRestoredSubscription = false;
  SubscriptionPlan? plan;

  @override
  void onInit() {
    super.onInit();

    // Check if the user role is player
    final String? role = state.sharedPreferencesManager.getString('selectedUserRole');
    final bool isPlayer = role == Constants.userRolePlayer;

    // Set TabController length based on role
    tabController = TabController(length: isPlayer ? 1 : 2, vsync: this);

    if (Platform.isIOS) {
      if (Get.arguments != null && Get.arguments is List) {
        final args = Get.arguments as List;

        // First argument → bool
        if (args.isNotEmpty && args[0] is bool) {
          isRestoredSubscription = args[0] as bool;
        } else {
          isRestoredSubscription = false;
        }

        // Second argument → SubscriptionPlan?
        if (args.length > 1 && args[1] is SubscriptionPlan) {
          plan = args[1] as SubscriptionPlan;
        } else {
          plan = null;
        }

        print("Restore from arguments ---> $isRestoredSubscription");
        print("SubscriptionPlan from arguments ---> $plan");
      } else {
        isRestoredSubscription = false;
        plan = null;
        print("No valid arguments found");
      }
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
