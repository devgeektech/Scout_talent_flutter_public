import 'package:get/get.dart';

import 'trial_player_detail_logic.dart';

class TrialPlayerDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrialPlayerDetailLogic(state: Get.find()));
  }
}