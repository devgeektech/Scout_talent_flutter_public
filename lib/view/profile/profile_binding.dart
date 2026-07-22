import 'package:get/get.dart';
import 'package:scouttalent2/view/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileController(parser: Get.find()),
    );
  }
}
