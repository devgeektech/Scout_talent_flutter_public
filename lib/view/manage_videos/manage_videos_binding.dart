import 'package:get/get.dart';

import 'manage_videos_logic.dart';

class ManageVideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManageVideosLogic(state: Get.find()));
  }
}
