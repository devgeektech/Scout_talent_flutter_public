import 'package:get/get.dart';
import 'my_trials_logic.dart';

class MyTrialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyTrialsLogic(state: Get.find()));
  }
}
