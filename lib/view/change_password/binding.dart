import 'package:get/get.dart';
import 'package:scouttalent2/view/change_password/logic.dart';


class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordLogic(state: Get.find()));
  }
}


