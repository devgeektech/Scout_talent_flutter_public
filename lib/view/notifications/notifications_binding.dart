import 'package:get/get.dart';

import 'notifications_logic.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => NotificationsLogic(state: Get.find()));
  }
}