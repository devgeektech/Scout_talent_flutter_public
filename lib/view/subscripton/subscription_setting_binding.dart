import 'package:get/get.dart';
import 'package:scouttalent2/view/subscripton/subscription_logic.dart';


class SubscriptionSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionSettingLogic(parser: Get.find()));
  }
}
