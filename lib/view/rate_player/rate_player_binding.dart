import 'package:get/get.dart';

import 'rate_player_logic.dart';

class RatePlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RatePlayerLogic(state: Get.find()));
  }
}
