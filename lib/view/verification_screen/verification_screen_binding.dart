import 'package:get/get.dart';
import 'verification_screen_logic.dart';

class VerificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerificationScreenLogic(state: Get.find()));
  }
}
