import 'package:get/get.dart';
import 'all_trials_logic.dart';


class AllTrialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllTrialsLogic(state: Get.find()));
  }
}
