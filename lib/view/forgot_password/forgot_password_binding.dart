import 'package:get/get.dart';
import 'package:scouttalent2/view/forgot_password/forgot_password_logic.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordLogic(state: Get.find()));
  }
}
