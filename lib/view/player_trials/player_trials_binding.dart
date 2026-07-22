import 'package:get/get.dart';
import 'package:scouttalent2/view/player_trials/player_trials_logic.dart';


class PlayerTrialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayerTrialsLogic(state: Get.find()));
  }
}
