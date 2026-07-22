import 'package:get/get.dart';
import 'package:scouttalent2/view/choose_your_account/choose_your_account_logic.dart';


class ChooseYourAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChooseYourAccountLogic(state: Get.find()));
  }
}
