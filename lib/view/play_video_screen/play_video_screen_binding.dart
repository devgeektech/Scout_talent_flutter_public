import 'package:get/get.dart';
import 'play_video_screen_logic.dart';


class PlayVideoScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayVideoScreenLogic(state: Get.find()));
  }
}
