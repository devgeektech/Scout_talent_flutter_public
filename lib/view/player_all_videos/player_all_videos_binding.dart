import 'package:get/get.dart';

import 'player_all_videos_logic.dart';


class PlayerAllVideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayerAllVideosLogic(state: Get.find()));
  }
}
