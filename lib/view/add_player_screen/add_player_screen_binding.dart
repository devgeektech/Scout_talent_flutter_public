import 'package:get/get.dart';
import 'add_player_screen_logic.dart';

class AddPlayerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddPlayerScreenLogic(state: Get.find()));
  }
}
