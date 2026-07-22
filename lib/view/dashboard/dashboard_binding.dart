import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(parser: Get.find()));
    Get.lazyPut(() => ProfileController(parser: Get.find()),fenix: true);
    Get.lazyPut(() => HomeScreenController(parser: Get.find()),fenix: true);

  }
}
