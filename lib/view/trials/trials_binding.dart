import 'package:get/get.dart';
import 'package:scouttalent2/view/trials/trials_logic.dart';


class TrialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrialsLogic (state: Get.find()));
  }
}
