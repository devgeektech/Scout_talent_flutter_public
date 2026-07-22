import 'package:get/get.dart';
import 'package:scouttalent2/view/players_list/players_list_logic.dart';

class PlayersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayersListLogic(state: Get.find()));
  }
}
