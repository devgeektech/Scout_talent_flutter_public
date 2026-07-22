import 'package:get/get.dart';
import 'package:scouttalent2/view/subscription/subscription_logic.dart';


class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionLogic(state: Get.find()));
  }
}
