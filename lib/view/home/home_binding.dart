import 'package:get/get.dart';
import 'home_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeScreenController(parser: Get.find()),
    );
  }
}
