import 'package:get/get.dart';

import 'player_activity_page_logic.dart';


class PlayerActivityPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayerActivityPageLogic(state: Get.find()));
  }
}
