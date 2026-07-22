import 'package:get/get.dart';

import 'chat_screen_logic.dart';

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => ChatScreenLogic(state: Get.find()));
  }
}