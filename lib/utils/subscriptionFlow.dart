import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/utils.dart';

class AppStateController extends GetxController {
  RxBool isFreeAccount = false.obs;
  RxBool hasSubscription = false.obs;

  Future<void> loadAccountFlags() async {
    isFreeAccount.value = await getFreeAccount();
    hasSubscription.value = await getHasSubscription();
    if (kDebugMode) {
      if (kDebugMode) {
        print("isFreeAccount.value---->${isFreeAccount.value}");
      }
    }
    if (kDebugMode) {
      print("hasSubscription.value---->${hasSubscription.value}");
    }
  }
}