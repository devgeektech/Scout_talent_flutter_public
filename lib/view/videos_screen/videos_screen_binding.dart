import 'package:get/get.dart';
import 'package:scouttalent2/view/videos_screen/videos_screen_logic.dart';

class VideosScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideosScreenLogic(state: Get.find()));
  }
}
