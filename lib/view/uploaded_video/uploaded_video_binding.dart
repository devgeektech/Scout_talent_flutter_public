import 'package:get/get.dart';
import 'package:scouttalent2/view/uploaded_video/uploaded_video_logic.dart';

class UploadedVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UploadedVideoLogic(state: Get.find()));
  }
}
