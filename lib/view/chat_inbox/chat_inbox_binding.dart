import 'package:get/get.dart';

import 'chat_inbox_logic.dart';

class ChatInboxBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => ChatInboxLogic(state: Get.find()));
  }
}