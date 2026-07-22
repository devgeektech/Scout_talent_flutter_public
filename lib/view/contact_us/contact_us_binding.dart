import 'package:get/get.dart';

import 'contact_us_logic.dart';


class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactUsLogic(state: Get.find()));
  }
}


