import 'package:get/get.dart';
import 'package:scouttalent2/view/subscription_pricing/subscription_pricing_logic.dart';


class SubscriptionPricingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionPricingLogic(state: Get.find()));
  }
}
